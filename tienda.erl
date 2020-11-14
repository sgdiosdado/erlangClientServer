% Iñaki Janeiro         - A00516978
% Sergio Diosdado       - A00516971
% Eduardo Guzmán Vega   - A01194108

% Módulo Tienda: Servidor que administra las suscripciones de socios y la venta de productos.
-module(tienda).
-export([getHostname/0, abre_tienda/0, tienda_serv/1]).

getHostname() -> 'tienda@MBP-de-Sergio'.

% Datos SCHEMA: [[{PID_Socio, Socio}], [productos], [servicios]]
abre_tienda() ->
  register(servidor_tienda,
    spawn(getHostname(), tienda, tienda_serv, [[[],[],[]]])).

tienda_serv(Datos) ->
  io:format("~p~n", [Datos]),
  receive
    {suscribe, {PID, Socio}} -> 
      % Añadir socio a Datos
      New_socio = subscribe_socio(PID, Socio, Datos),
      if hd(New_socio) == ok ->
        PID ! ok,
        tienda_serv(tl(New_socio));
      true -> PID ! error, tienda_serv(Datos)
      end;

    {elimina, {PID, Socio}} -> 
      New_datos = elimina_socio(PID, Socio, Datos),
      if hd(New_datos) == ok ->
        PID ! ok,
        tienda_serv(tl(New_datos));
      true -> PID ! error, tienda_serv(Datos)
      end;
    
    {registra_producto, {PID, Producto, Cantidad}} ->
      New_producto = registra_producto(PID, Producto, Cantidad, Datos),
      if hd(New_producto) == ok ->
        PID ! ok,
        tienda_serv(tl(New_producto));
        true -> PID ! error, tienda_serv(Datos)
      end;

    {elimina_producto, {PID, Producto, Cantidad}} -> 
      New_datos = elimina_producto(PID, Producto, Cantidad, Datos),
      if hd(New_datos) == ok ->
        PID ! ok,
        tienda_serv(tl(New_datos));
      true -> PID ! error, tienda_serv(Datos)
      end;
    _ -> 
      io:format("Mensaje incorrecto ~n")

  end.
    
subscribe_socio(PID, Socio, [ListaSocios | R]) ->
    case busca(Socio, ListaSocios) of 
      false -> 
        io:format("Socio ~p se añadió~n", [Socio]),
        [ok | [ListaSocios ++ [{PID, Socio}] | R]];
      true -> [error | [ListaSocios | R]]
    end
    . 

elimina_socio(_, Socio, [ListaSocios | R]) ->
  case busca(Socio, ListaSocios) of
    true ->
      io:format("Socio ~p se eliminó~n", [Socio]),
      [ok | [elimina(Socio, ListaSocios) | R]];
    false -> [error]
  end
.

% Acciones de productos
registra_producto(PID, Producto, Cantidad, [ListaSocios, ListaProductos | R]) ->
  case buscaProducto(Producto, ListaProductos) of
    false ->
      io:format("Producto ~p se añadió~n", [Producto]),
      [ok | [ListaSocios | [ListaProductos ++ [{PID, Producto, Cantidad}] | R]]];
    true -> [error | [ListaSocios | [ListaProductos | R]]]
  end
.

elimina_producto(_, Producto, _, [H, ListaProductos | R]) ->
  case buscaProducto(Producto, ListaProductos) of
    true ->
      io:format("Producto ~p se eliminó~n", [Producto]),
      [ok | [H | [elimina_producto(Producto, ListaProductos) | R]]];
    false -> [error | [H | [ListaProductos | R]]]
  end
.

%
% Utilidades
%
busca(Valor, [{_, Valor}|_]) -> 
  true;
busca(Valor, [_|T]) ->
  busca(Valor, T);
busca(_, _) -> 
  false.

buscaProducto(Valor, [{_, Valor, _}|_]) ->
  true;
buscaProducto(Valor, [_|T]) ->
  buscaProducto(Valor, T);
buscaProducto(_, _) -> 
  false.

elimina(Valor, ListaSocios) ->
  lists:filter(fun({_, X}) -> X /= Valor end, ListaSocios)
.

elimina_producto(Valor, ListaProductos) ->
  lists:filter(fun({_, X, _}) -> X /= Valor end, ListaProductos)
.
