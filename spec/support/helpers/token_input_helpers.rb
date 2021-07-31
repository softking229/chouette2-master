require 'capybara'
require 'capybara/dsl'

module TokenInputHelper
  include Capybara::DSL
  
  # EX: fill_in_token_input 'custodian_id', with: 'M', pick: 'Market'
  # EX: fill_in_token_input 'custodian_id', with: 'A', pick: 1
  #
  # @param id [String] id of the original text input that has been replaced by the tokenInput
  # @option with [String] *required
  # @option pick [Symbol, String, Integer] result to pick, defaults to first result
  #
  def fill_in_token_input(id, options)
    # Generate selectors for key elements
    # The tokenInput-generated visible text field
    text_input_selector = "#token-input-#{id}"
    # The <ul> tag containing the selected tokens and visible test input
    token_input_list_selector = ".token-input-list:has(li #{text_input_selector})"
    # The result list
    result_list_selector = ".token-input-selected-dropdown-item"

    # Trigger clicking on the token input
    page.driver.execute_script("$('#{token_input_list_selector}').trigger('click');")
    # Wait until the 'Type in a search term' box appears
    #page.has_css? ".token-input-dropdown:contains('Type in a search term')"

    # Fill in the visible text box
    page.driver.execute_script("$('#{text_input_selector}').val('#{options[:with]}');")
    # Triggering keydown initiates the ajax request within tokenInput
    page.driver.execute_script("$('#{text_input_selector}').trigger('keydown');")
    # The result_list_selector will show when the AJAX request is complete
    page.has_css? result_list_selector

    # Pick the result
    if options[:pick]
      textual_numbers = [:first, :second, :third, :fourth, :fifth]
      if index = textual_numbers.index(options[:pick])
        selector = ":nth-child(#{index+1})"
      elsif options[:pick].class == String
        selector = ":contains(\"#{options[:pick]}\")"
      elsif options[:pick].class == Integer
        selector = ":nth-child(#{options[:pick]})"
      end
    else
      selector = ':first-child'
    end

    page.driver.execute_script("$('#{result_list_selector}#{selector}').trigger('mousedown');")
    # A missing result_list_selector signifies that the selection has been made
    page.has_css?(result_list_selector)
  end

  # Focus on a tokenInput
  # @param id [String] *required
  #
  def focus_on_token_input(id)
    page.driver.execute_script("$('##{id}').siblings('ul').trigger('click')")
    sleep(0.1)
  end

  # Get the JS array of tokens in a tokenInput instance
  # @param id [String] *required
  #
  def get_token_input(id)
    page.driver.execute_script("$('##{id}').tokenInput('get')")
  end

  # Clears a tokenInput
  # @param id [String] *required
  #
  def clear_token_input(id, options={})
    page.driver.execute_script("$('##{id}').tokenInput('clear', #{options.to_json})")
    sleep(0.1)
  end
  
end
