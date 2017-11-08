class Lista_filmes < AndroidScreenBase
  # Identificador da tela
  trait(:trait)                                 { "* marked:'#{layout_name}'" }
  # Declare todos os elementos da tela
  element(:layout_name)                             { 'home_omdb'}


  def realizar_busca
    keyboard_enter_text "Batman Forever"
    touch("* id:'search'")
  end

  def resultado_busca_titulo
    element_exists("* text:'Batman Forever'")
  end

  def tocar_favorito
    touch("* id:'favorite'")
  end

  def verificar_favoritos 
    touch("* text:'Favoritos'")
    query("* id:'movie'").size == 1
  end 


end
