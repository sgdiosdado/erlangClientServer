% Iñaki Janeiro         - A00516978
% Sergio Diosdado       - A00516971
% Eduardo Guzmán Vega   - A01194108

% Módulo Producto: Artículos registrados en la tienda, que pueden ser comprados por los socios.
-module(producto).
-export([registra_producto/2, elimina_producto/1, pruebas/0]).
-import(tienda, [getHostname/0]).

registra_producto(Producto, Cantidad) ->
  Matriz = getHostname(),
  monitor_node(Matriz, true),
  {servidor_tienda, Matriz} ! {registra_producto, {self(), Producto, Cantidad}},
  receive
    {nodedown, Matriz} ->
      no;
    ok ->
      io:format("Producto ~p registrado correctamente~n", [Producto]);
    error ->
      io:format("Hubo un error al registrar el producto ~p~n", [Producto])
  after 2000 ->
    io:format("TIME OUT ERROR~n")
  end.

elimina_producto(Producto) ->
  Matriz = getHostname(),
  monitor_node(Matriz, true),
  {servidor_tienda, Matriz} ! {elimina, {self(), Producto}},
  receive
    {nodedown, Matriz} ->
      no;
    ok ->
      io:format("Producto ~p eliminado~n", [Producto]);
    error ->
      io:format("Hubo un error al eliminar el producto ~p~n", [Producto])
    after 2000 ->
      io:format("TIME OUT ERROR~n")
  end
.

pruebas() ->
  producto:registra_producto(manzana, 5),
  producto:registra_producto(pera, 7),
  producto:registra_producto(guayaba, 32),

  producto:registra_producto(pera, 3),

  producto:elimina_producto(manzana).