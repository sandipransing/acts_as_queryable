## Rails acts as queryable

A lot times, we come up with requirements like - 
  1. list records for entity,
  2. Apply default query criteria,
  3. Add/subtracts display columns,
  3. Add various filters for different fields,
  4. Save my filters for future quick usage (mark filter as favourite),
  5. Export records in different formats like pdf, csv, text (download what i see)

Currently, gem scope is limited to mysql but in near by future we have plan to implement it for different ORM
  
## How much code do i need to write?

### Example:

  class Payment < ActiveRecord::Base
    acts_as_queryable { 
      :fields => {
        'id' => {},
        'order_id' => {},
        'type' => {},
        'amount' => { :kind => :money },
        'created_at' => { :kind => :date }
        'updated_at' => { :kind => :date },
        'succeeded_at' => { :kind => :date },
        'failed_at' => { :kind => :date },
        'gateway_status' => {},
        'status' => {}
      },
      :default_fields => [ 'updated_at', 'type', 'status', 'amount' ],
      :default_order => 'id-'
    }
  end


fields hash contains the database fields

default_fields are the default ones which are displayed when no columns are selected

default_order ascending or descending

== Controller

  def index
    respond_to do |wants|
      wants.html { @payments = Payment.query_find( params ); save_query_params_to_preferences( @payments ) }
      wants.csv  { render_query_results_as_csv( Payment.query_find( params, QUERY_CSV_OPTIONS ) ) }
    end
  end


== Partial Views
  <%= render :partial => '/shared/query_filters', :locals => { :collection => @payments } %>
  <%= render :partial => '/shared/query_results_table', :locals => { :collection => @payments } %>

== Sample index HTML:
    <div id="field-selector" class="tools-dropdown-menu">
    <ul class="sortable-fields" id="selected-fields">
      <% @collection.queried_field_names.each do |title, name| -%>
        <li id="<%=name%>"><input type="checkbox" id="<%= name -%>_checkbox" value="1" checked /> <%=h title -%></li>
      <% end -%>
      <% @collection.unqueried_field_names.each do |title, name| -%>
        <li id="<%=name%>"><input type="checkbox" id="<%= name -%>_checkbox" value="1" unchecked /> <%=h title -%></li>
      <% end -%>
    </ul>

  <script type="text/javascript">
  // <![CDATA[
    Sortable.create("selected-fields",
      { 
        dropOnEmpty: true,
        containment: ["selected-fields"],
        constraint: false
      }
    );
  // ]]>
  </script>
</div>
<table width="100%">
<tr>
  <td  align="right">
    <%= submit_tag "Update", :onclick => "updateFieldsValue();this.disable();$('query-form').submit();" %>
    <%= submit_tag "Cancel", :onclick => "Modalbox.hide();" %>
  </td>
</tr>
</table>
