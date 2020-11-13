-module(tienda).
-export([init_tienda/0, tienda/0]).


init_tienda() ->
    register(servidor_tienda,
        spawn('tienda@Inakis-MacBook-Pro', fun tienda/0)).
tienda() ->
    receive
        {PID, _} ->
            io:format("Hola, soy la tienda ~n"),
            PID ! "¡Mensaje llego bien a tienda!",
            tienda();
        _ -> 
            io:format("Mensaje incorrecto ~n")

    end.