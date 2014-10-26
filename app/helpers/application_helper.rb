module ApplicationHelper
  def select_box(f, attribute, data)
    input(f, attribute, :text) do
      f.collection_select(attribute, data, :id, :name, {}, :class  => 'form-control')
    end
  end

  def input_check_box(f, attribute, selected)
    input(f, attribute, :text) do
      f.check_box(attribute)
    end
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

  def input(f, attribute, type, options = {})
    errors, html_error = check_errors(f, attribute)
    cl_options = default_form_class.merge(options.include?(:class) ? options[:class] : {})
    with_label = !options.include?(:bare) || !options[:bare]

    if with_label
      haml_tag 'div', :class  => "form-group#{html_error}" do
        haml_concat f.label(attribute, :class  => "#{cl_options[:label]} control-label")

        haml_tag 'div', :class  => cl_options[:input] do
          haml_concat yield(options.except(:class)) if block_given?
          errors.each do |error|
            haml_tag 'span', :class => 'help-block' do
              haml_concat error
            end #span
          end #errors.each
        end # div input
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
    input(f, attribute, type, options) do
      f.text_area(attribute, :class  => 'form-control', type: type)
    end
  end

  def input_field(f, attribute, type = :text, options = {})
    input(f, attribute, type, options) do |opts|
      f.text_field(attribute, { :class  => 'form-control', type: type}.merge(opts))
    end
  end

  def input_datetime(f, attribute, options = {})
    input(f, attribute, :text, options) do |opts|
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
