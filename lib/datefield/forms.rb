module ActionView
  DATEFIELD_DEFAULT_OPTIONS = {
      :show_other_months => true,
      :select_other_months => true,
      :date_format => 'yy-mm-dd',
      :show_button_panel => true,
      :constrain_input => false,
      :show_on => 'button',
      :button_image => '/calendar.gif',
      :button_image_only => true,
      :today_button_triggers_today => true
  }

  module Helpers
    module FormHelper
      def date_field(object_name, method, tag_options = {})
        date_options = tag_options.delete(:date_field) || {}
        date_options.reverse_merge!(DATEFIELD_DEFAULT_OPTIONS)
        today_button = date_options.delete(:today_button_triggers_today)

        new_date_options = {}
        date_options.each_key do |k|
          new_date_options[k.javascript_camelize] = date_options[k]
        end

        output = <<-OUTPUT
#{tag = text_field(object_name, method, tag_options)}
          <script type="text/javascript">
if ('undefined' === typeof(today_fields)) {
  var today_fields = [];
}
          $(document).ready(function(ev) {
            $("##{tag.match(/id="([^"]+)"/)[1]}").datepicker(#{new_date_options.to_json});
        OUTPUT

        if today_button
          output += <<-OUTPUT
          $.datepicker._gotoToday = function(id) {
              var target = $(id);
              var inst = this._getInst(target[0]);
              if (this._get(inst, 'gotoCurrent') && inst.currentDay) {
                      inst.selectedDay = inst.currentDay;
                      inst.drawMonth = inst.selectedMonth = inst.currentMonth;
                      inst.drawYear = inst.selectedYear = inst.currentYear;
              }
              else {
                      var date = new Date();
                      inst.selectedDay = date.getDate();
                      inst.drawMonth = inst.selectedMonth = date.getMonth();
                      inst.drawYear = inst.selectedYear = date.getFullYear();
                  if ($.inArray(id, today_fields) !== -1) {
                      this._setDateDatepicker(target, date);
                      this._selectDate(id, this._getDateDatepicker(target));
                  }
              }
              this._notifyChange(inst);
              this._adjustDate(target);
          }
          OUTPUT
        end
        output += "})</script>"
        output
      end
    end

    module FormTagHelper
      def date_field_tag(name, value = nil, options = {})
        date_options = options.delete(:date_field) || {}
        date_options.reverse_merge!(DATEFIELD_DEFAULT_OPTIONS)
        today_button = date_options.delete(:today_button_triggers_today)

        new_date_options = {}
        date_options.each_key do |k|
          new_date_options[k.javascript_camelize] = date_options[k]
        end

        output = <<-OUTPUT
#{tag :input, { "type" => "text", "name" => name, "id" => sanitize_to_id(name), "value" => value }.update(options.stringify_keys)}
                <script type="text/javascript">
if ('undefined' === typeof(today_fields)) {
  var today_fields = [];
}
                $(document).ready(function(ev) {
                  $("##{sanitize_to_id(name)}").datepicker(#{new_date_options.to_json});
        OUTPUT
        if today_button
          output += <<-OUTPUT
          today_fields.push("##{sanitize_to_id(name)}");
      $.datepicker._gotoToday = function(id) {
          var target = $(id);
          var inst = this._getInst(target[0]);
          if (this._get(inst, 'gotoCurrent') && inst.currentDay) {
                  inst.selectedDay = inst.currentDay;
                  inst.drawMonth = inst.selectedMonth = inst.currentMonth;
                  inst.drawYear = inst.selectedYear = inst.currentYear;
          }
          else {
                  var date = new Date();
                  inst.selectedDay = date.getDate();
                  inst.drawMonth = inst.selectedMonth = date.getMonth();
                  inst.drawYear = inst.selectedYear = date.getFullYear();
              if ($.inArray(id, today_fields) !== -1) {
                  this._setDateDatepicker(target, date);
                  this._selectDate(id, this._getDateDatepicker(target));
              }
          }
          this._notifyChange(inst);
          this._adjustDate(target);
      }
          OUTPUT
        end
        output += "})</script>"

        output
      end
    end

    class FormBuilder
      def date_field(method, options = {})
        raw @template.send(
            'date_field',
            @object_name,
            method,
            objectify_options(options))
      end
    end
  end
end