Kaminari.configure do |config|
  # Tamanho padrão de página (global)
  config.default_per_page = 10

  # Limite máximo permitido via ?per= (protege de per=100000)
  config.max_per_page = 100

  # Quantas páginas vizinhas mostrar no paginador
  config.window = 2
  config.outer_window = 0
  config.left = 0
  config.right = 0

  # Nome do método e do parâmetro
  config.page_method_name = :page
  config.param_name = :page

  # Manter ?page=1 na URL? (false remove)
  config.params_on_first_page = false
end
