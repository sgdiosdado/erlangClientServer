-module(socio).
-export([suscribir_socio/1]).

% nombre largo del servidor (nombre@máquina)
matriz() -> 'tienda@Inakis-MacBook-Pro'.

% funciones de interfase
% consulta(Quien) ->
%     llama_banco({consulta, Quien}).
% deposita(Quien, Cantidad) ->
%     llama_banco({deposita, Quien, Cantidad}).
% retira(Quien, Cantidad) ->
%     llama_banco({retira, Quien, Cantidad}).
% % cliente
suscribir_socio(Socio) ->
    Matriz = matriz(),
    monitor_node(Matriz, true),
    {servidor_tienda, Matriz} ! {self(), mensaje},
    receive
        {servidor_banco, Respuesta} ->
            monitor_node(Matriz, false),
            Respuesta;
        {nodedown, Matriz} ->
            no;
        PorLoProntoParaProbar ->
            io:format("Mensaje recibido: ~p~n", [PorLoProntoParaProbar])
    end.