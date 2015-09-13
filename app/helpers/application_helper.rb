# This file is part of Rails PowerDNS Admin
#
# Copyright (C) 2014-2015  Dennis <allspark> Börm
#
# Rails PowerDNS Admin is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
# Rails PowerDNS Admin is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Rails PowerDNS Admin.  If not, see <http://www.gnu.org/licenses/>.

module ApplicationHelper
  def fa(icon)
     capture_haml do
       surround ' ', ' ' do
         fa_icon(icon)
       end
     end
  end

  def select_box(f, attribute, data, options = {})
    input f, attribute, :text, {}, proc {
      f.collection_select(attribute, data, :id, :name, options, :class  => 'form-control')
    }
  end

  def input_check_box(f, attribute, selected)
    input f, attribute, :text, {}, proc {
      f.check_box(attribute)
    }
  end

  def default_form_class()
    { label: 'col-lg-2', input: 'col-lg-10', submit: 'col-lg-offset-2 col-lg-10' }
  end

  def check_errors(f, attribute)
    errors = f.object.errors[attribute]
    html_error = nil
    html_error = ' has-error' if !errors.empty?

    [errors, html_error]
  end

  def input(f, attribute, type, options, main_field, *inputs)
    errors, html_error = check_errors(f, attribute)
    cl_options = default_form_class.merge(options.include?(:class) ? options[:class] : {})
    with_label = !options.include?(:bare) || !options[:bare]

    if with_label
      haml_tag 'div', :class  => "form-group#{html_error}" do
        haml_concat f.label(attribute, :class  => "#{cl_options[:label]} control-label")

        haml_tag 'div', :class  => cl_options[:input] do
          haml_concat main_field.(options.except(:class))
          errors.each do |error|
            haml_tag 'span', :class => 'help-block' do
              haml_concat error
            end #span
          end #errors.each
        end # div input
        inputs.each do |input_field|
          haml_tag 'div', class: input_field[:class] do
            haml_concat input_field[:field].()
          end
        end
      end # div form-group
    else
      haml_tag 'div', :class  => "#{html_error}" do
        haml_concat yield(options.except(:class)) if block_given?
        errors.each do |error|
          haml_tag 'span', :class  => 'help-block' do
            haml_concat error
          end #span
        end #errors.each
      end
    end # if

  end

  def input_area(f, attribute, type, options = {})
    input f, attribute, type, options, proc {
      f.text_area(attribute, :class  => 'form-control', type: type)
    }
  end

  def input_field(f, attribute, type = :text, options = {})
    input f, attribute, type, options, lambda { |opts|
      f.text_field(attribute, { :class  => 'form-control', type: type}.merge(opts))
    }
  end

  def input_field_2(f, attribute, name, value, type = :text, options = {})
    input f, attribute, type, {class: {input: 'col-lg-8'}}.merge(options), proc { |opts|
      f.text_field(attribute, { class: 'form-control', type: type}.merge(opts))
    }, { class: 'col-lg-2', field: proc { text_field_tag(name, value, disabled: true, class: 'form-control') } }

  end

  def input_datetime(f, attribute, options = {})
    input f, attribute, :text, options, proc do |opts|
      f.text_field(attribute, { :class  => 'form-control datetimepicker', type: :text}.merge(opts))
    end
  end

  def submit_button(f, button_class, options = {})
    cl_options = options.include?(:class) ? options[:class] : default_form_class[:submit]
    text = options[:text]
    haml_tag 'div', :class=> 'form-group' do
      haml_tag 'div', :class=> cl_options do
        haml_concat f.submit(text, :class=> "btn btn-#{button_class}")
      end
    end
  end

end
