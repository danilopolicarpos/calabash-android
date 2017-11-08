require 'calabash-android/abase'
require 'pry'
class AndroidScreenBase < Calabash::ABase
  def self.element(element_name, &block)
    define_method(element_name.to_s, *block)
  end
  class << self
    alias :value :element
    alias :action :element
    alias :trait :element
  end
  # element(:loading_screen)      { 'insert_loading_view_id' }
  element(:loading_screen)        { 'material_progress_bar' }
  element(:btn_menu)              { 'android.widget.ImageButton' }
  element(:token)                 { 'token_type_container' }
  element(:campo_token)           { 'token_number_edit' }
  element(:btn_ok_token)          { 'token_primary_action' }
  action(:tocar_menu) {
    touch("#{btn_menu}")
  }
  action(:reiniciar_app) {
    start_test_server_in_background
  }
  action(:apagar_caracter) {
    press_button('KEYCODE_DEL')
  }
 
  def visivel?(id, query = nil)
    query = "* id:'#{id}'" if query.nil?
    begin
      wait_for(timeout: 3) { element_exists query }
    rescue
      return false
    end
    true
  end
  # The progress bar of the application is a custom view
  def wait_for_progress
    wait_for(timeout: 45) { element_does_not_exist("* marked:'material_progress_bar'") }
  end
  def drag_to direction
    positions = [0,0,0,0] # [ 'from_x', 'to_x', 'from_y', 'to_y' ]
    case(direction)
    when :baixo
      positions = [30,30,60,30]
    when :cima
      positions = [80,80,60,90]
    when :esquerda
      positions = [90,20,80,80]
    when :direita
      positions = [20,90,80,80]
    end
    # perform_action( 'action', 'from_x', 'to_x', 'from_y', 'to_y', 'number of steps (in this case, velocity of drag' )
    perform_action('drag', positions[0], positions[1], positions[2], positions[3], 15)
    sleep(1)
  end
  def drag_until_element_is_visible_with_special_query direction, element
    drag_until_element_is_visible direction, element, "* {text CONTAINS[c] '#{element}'}"
  end
  def drag_until_element_is_visible direction, element, query = nil, limit = 15
    i = 0
    element_query = ""
    if query.nil?
      element_query = "* marked:'#{element}'"
    else
      element_query = query
    end
    sleep(2)
    while( !element_exists(element_query) and i < limit) do
      drag_to direction
      i = i + 1
    end
    raise ("Executed #{limit} moviments #{direction.to_s} and the element '#{element}' was not found on this view!") unless i < limit
  end
  def drag_for_specified_number_of_times direction, times
    times.times do
      drag_to direction
    end
  end
  # Negation indicates that we want a page that doesn't has the message passed as parameter
  def is_on_page? page_text, negation = ''
    should_not_have_exception = false
    should_have_exception = false
    begin
      wait_for(timeout: 5) { has_text? page_text }
      # If negation is not nil, we should raise an error if this message was found on the view
      should_not_have_exception = true unless negation == ''
    rescue
      # only raise exception if negation is nil, otherwise this is the expected behaviour
      should_have_exception = true if negation == ''
    end
    raise "Unexpected Page. The page should not have: '#{page_text}'" if should_not_have_exception
    raise "Unexpected Page. Expected was: '#{page_text}'" if should_have_exception
  end
  def enter text, element, query = nil
    if query.nil?
      query( "* marked:'#{element}'", {:setText => text} )
    else
      query( query, {:setText => text} )
    end
  end
  def touch_screen_element(element, query = nil, timeout = 5)
    query = "* id:'#{element}'" if query.nil?
    begin
      wait_for(timeout: timeout) { element_exists(query) }
      touch(query)
    rescue => e
      raise "Problema em tocar no elemento da tela: '#{element}'\nMensagem de erro: #{e.message}"
    end
  end
  def touch_element_by_index id, index
    wait_for(:timeout => 5) { element_exists("* id:'#{id}' index:#{index}") }
    touch("* id:'#{id}' index:#{index}")
  end
  def clear_text_field field
    clear_text_in("android.widget.EditText id:'#{field}'}")
  end
 def select_date_on_date_picker date, date_picker_field_id
    # Touch the date picker field
    touch "* id:'#{date_picker_field_id}'"
    # Setting the date
    set_date 'materialdatetimepicker', date.year, date.month, date.day
    # Clicking in the Done button
    touch "* id:'ok'"
  end
  def enter_password password
    begin
      password.split('').each do |number|
        touch("android.support.v7.widget.AppCompatButton {text CONTAINS[c] '#{number}'}")
      end
    rescue
      raise "o número #{number} não foi encontrado"
    end
    #
    #
    # password.split('').each do |number|
    #   # No teclado virtual, o numero pode vir antes ou depois do texto 'ou', ex.: '0 ou 1'
    #   if element_exists("android.widget.TextView {text CONTAINS[c] '#{number}'}")
    #     touch("android.widget.TextView {text CONTAINS[c] 'ou #{number}'}")
    #   elsif element_exists("android.widget.TextView {text CONTAINS[c] '#{number} ou'}")
    #     touch("android.widget.TextView {text CONTAINS[c] '#{number} ou'}")
    #   else
    #     raise 'Number not found on this view'
    #   end
    # end
  end
  def print
    dia = DateTime.now.day.to_s
    mes = DateTime.now.month.to_s
    ano = DateTime.now.year.to_s
    screenshot_embed(:prefix => "prints/android/", :name => "tela_#{" " + dia + ":" + mes + ":" + ano} #{Time.now.strftime("%H %M %S ")}")
  end
  def tocar elemento
    touch("* text:'#{elemento}'")
  end
  def ver_mensagem
	  wait_for_element_exists("* id:'texto_mensagem_erro'")
  end
  def ver_mensagem_formulario mensagem
    wait_for_element_exists("* marked:'#{mensagem}'")
  end
  def vejo_msg_erro msg
    sleep 2
    erros = query "br.com.itau.widgets.material.MaterialEditText", :error
    result = false
    erros.each do |erro|
      if erro.to_s == msg
        result = true
      end
    end
    return result
  end
  def scroll_spinner spinner, item
    touch_screen_element spinner
    i = 0
    sleep 2
    while( !element_exists("* marked:'#{item}'") and i < 5) do
      scroll("android.widget.ListPopupWindow$DropDownListView", :down)
      i = i + 1
    end
    touch "* marked:'#{item}'"
  end
  def fechar_coach_mark
    sleep 1
    if query("* {id CONTAINS 'botao_fechar_coach_'}").size > 0
      touch_screen_element 'ico_fechar_branco', "* {id CONTAINS 'botao_fechar_coach_'}"
      sleep 1
    end
    if query("* marked:'botao_fechar_coach_mark'}").size > 0
      touch_screen_element 'ico_fechar_branco', "* marked:'botao_fechar_coach_mark'}"
      sleep 1
    end
  end
  def vejo_coachMark?
    sleep 2
    wait_for_progress
    sleep 2
    query("* {id CONTAINS 'coach_mark_'}").size > 0
  end
  def validar_token
    wait_for_element_exists("* id:'#{token}'")
    if query("* id:'#{token}'").size > 1
      touch "* id:'#{token}' index:2"
    else
      wait_for_element_exists "* marked:'#{token}'"
      touch_screen_element token
    end
   begin
     touch_screen_element campo_token
   rescue
     touch_screen_element token
     touch_screen_element campo_token
   end
   keyboard_enter_text '111111'
   touch_screen_element btn_ok_token
   wait_for_progress
 end
end