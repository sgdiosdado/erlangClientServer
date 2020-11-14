% Iñaki Janeiro         - A00516978
% Sergio Diosdado       - A00516971
% Eduardo Guzmán Vega   - A01194108

% Módulo Tienda: Servidor que administra las suscripciones de socios y la venta de productos.
-module(tienda).
-export([getHostname/0, abre_tienda/0, tienda_serv/1]).

getHostname() -> 'tienda@Inakis-MacBook-Pro'.

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

    {elimina_producto, {PID, Producto}} -> 
      New_datos = elimina_producto(PID, Producto, Datos),
      if hd(New_datos) == ok ->
        PID ! ok,
        tienda_serv(tl(New_datos));
      true -> PID ! error, tienda_serv(Datos)
      end;
    {modifica_producto, {PID, Producto, Cantidad}} -> 
      tienda_serv(modifica_producto(PID, Producto, Cantidad, Datos));
    {lista_existencias, PID} -> 
        PID ! getProductos(Datos),
        tienda_serv(Datos);
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
  case busca_Producto(Producto, ListaProductos) of
    false ->
      io:format("Producto ~p se añadió~n", [Producto]),
      [ok | [ListaSocios | [ListaProductos ++ [{PID, Producto, Cantidad}] | R]]];
    true -> [error | [ListaSocios | [ListaProductos | R]]]
  end
.

elimina_producto(_, Producto, [H, ListaProductos | R]) ->
  case busca_Producto(Producto, ListaProductos) of
    true ->
      io:format("Producto ~p se eliminó~n", [Producto]),
      [ok | [H | [elimina_producto(Producto, ListaProductos) | R]]];
    false -> [error | [H | [ListaProductos | R]]]
  end
.

modifica_producto(_, Producto, Cantidad, [ListaSocios, ListaProductos | R]) ->
  [ListaSocios | [modifica_producto(Producto, Cantidad, ListaProductos) | R]]  
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

busca_Producto(Valor, [{_, Valor, _}|_]) ->
  true;
busca_Producto(Valor, [_|T]) ->
  busca_Producto(Valor, T);
busca_Producto(_, _) -> 
  false.

modifica_producto(Producto, Cantidad, [{PID, Producto, CantidadVieja}|T]) ->
    if Cantidad + CantidadVieja >= 0 ->
        PID ! ok,
        [{PID, Producto, CantidadVieja+Cantidad}|T];
        true -> PID ! error, io:format("No se pudo modificar porque el producto no tiene suficientes existencias~n"),
        [{PID, Producto, CantidadVieja} | T] 
    end;
modifica_producto(Producto, Cantidad, [H|T]) ->
    [H|modifica_producto(Producto, Cantidad, T)];
modifica_producto(_, _, []) ->
    io:format("No se encontro el producto~n"),
    [].

elimina(Valor, ListaSocios) ->
  lists:filter(fun({_, X}) -> X /= Valor end, ListaSocios)
.

elimina_producto(Valor, ListaProductos) ->
  lists:filter(fun({_, X, _}) -> X /= Valor end, ListaProductos)
.

getProductos([_, Productos, _]) ->
    Productos.

getSocios([Socios, _, _]) ->
    Socios.
