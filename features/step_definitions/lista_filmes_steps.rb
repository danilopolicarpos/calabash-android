Dado('que estou na lista de filmes') do
  @page = page(Lista_filmes).await(timeout: 4)
end

Quando('realizar uma busca por titulo') do
  @page.realizar_busca
end

Então('vejo o resultado da busca') do
  fail'Não encontrou resultado da busca'unless @page.resultado_busca_titulo
end

Quando("favoritar o filme desejado") do
  @page.tocar_favorito
end

Então("vejo o filme favoritado na aba favoritos") do
 fail'Não encontrou filme favorito'unless @page.verificar_favoritos
end
