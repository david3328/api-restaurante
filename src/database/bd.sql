PGDMP                         w            bdrestaurante    10.8    10.8 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    16552    bdrestaurante    DATABASE     �   CREATE DATABASE bdrestaurante WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Spanish_Latin America.1252' LC_CTYPE = 'Spanish_Latin America.1252';
    DROP DATABASE bdrestaurante;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    4                        3079    12924    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                        3079    16790    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                  false    4            �           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                       false    2            �            1255    16787 3   cliente_insertarcliente(integer, character varying)    FUNCTION     �   CREATE FUNCTION public.cliente_insertarcliente(_idpersona integer, _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	insert into cliente (idpersona,altausuario,ultimousuario) 
	values (_idpersona,_usuario,_usuario);
end;
$$;
 ^   DROP FUNCTION public.cliente_insertarcliente(_idpersona integer, _usuario character varying);
       public       postgres    false    1    4            �            1255    16788    cliente_listarcliente()    FUNCTION       CREATE FUNCTION public.cliente_listarcliente() RETURNS TABLE(cli_nombres character varying, cli_apellidopaterno character varying, cli_apellidomaterno character varying, cli_dni character, cli_telefono character varying, cli_celular character varying, cli_email character varying, cli_altafecha timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
begin
	
	return query 
	select nombres,apellidopaterno,apellidomaterno,dni,telefono,celular,email,
	c.altafecha from cliente c 
	inner join persona p on p.id = c.idpersona; 

end;
$$;
 .   DROP FUNCTION public.cliente_listarcliente();
       public       postgres    false    1    4                       1255    16830 L   mesa_actualizarmesa(integer, smallint, smallint, boolean, character varying)    FUNCTION     n  CREATE FUNCTION public.mesa_actualizarmesa(_idmesa integer, _numero smallint, _capacidad smallint, _estado boolean, _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	update mesa set
	numero = _numero,
	capacidad = _capacidad,
	estado = _estado,
	ultimousuario = _usuario,
	ultimafechamodificacion = default
	where id = _idmesa;
end;
$$;
 �   DROP FUNCTION public.mesa_actualizarmesa(_idmesa integer, _numero smallint, _capacidad smallint, _estado boolean, _usuario character varying);
       public       postgres    false    1    4                       1255    16827 8   mesa_insertarmesa(smallint, smallint, character varying)    FUNCTION       CREATE FUNCTION public.mesa_insertarmesa(_numero smallint, _capacidad smallint, _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	insert into mesa (numero,capacidad,altausuario,ultimousuario)
	values (_numero,_capacidad,_usuario,_usuario);
end;
$$;
 k   DROP FUNCTION public.mesa_insertarmesa(_numero smallint, _capacidad smallint, _usuario character varying);
       public       postgres    false    4    1                       1255    16831    mesa_listarmesa(boolean)    FUNCTION       CREATE FUNCTION public.mesa_listarmesa(_estado boolean) RETURNS TABLE(mesa_id integer, mesa_numero smallint, mesa_capacidad smallint)
    LANGUAGE plpgsql STRICT
    AS $$
begin
	return query 
	select id,numero,capacidad from mesa where estado = _estado;
end;
$$;
 7   DROP FUNCTION public.mesa_listarmesa(_estado boolean);
       public       postgres    false    1    4                       1255    16857 /   pedido_anularpedido(integer, character varying)    FUNCTION     "  CREATE FUNCTION public.pedido_anularpedido(_idpedido integer, _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	update pedido set 
	situacion = 'C',
	estado = false,
	ultimafechamodificacion = default,
	ultimousuario = _usuario 
	where id = _idpedido;
end;
$$;
 Y   DROP FUNCTION public.pedido_anularpedido(_idpedido integer, _usuario character varying);
       public       postgres    false    4    1                        1255    16861 2   pedido_despacharpedido(integer, character varying)    FUNCTION       CREATE FUNCTION public.pedido_despacharpedido(_idpedido integer, _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	update pedido set 
	situacion = 'A',
	ultimafechamodificacion = default,
	ultimousuario = _usuario 
	where id = _idpedido;
end;
$$;
 \   DROP FUNCTION public.pedido_despacharpedido(_idpedido integer, _usuario character varying);
       public       postgres    false    1    4                       1255    16860    pedido_detallepedido(integer)    FUNCTION     P  CREATE FUNCTION public.pedido_detallepedido(_idpedido integer) RETURNS TABLE(pedido_cantidad smallint, plato_nombre character varying)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select cantidad,nombre from platopedido pp 
	inner join plato p on p.id = pp.idplato 
	where pp.estado = true and pp.idpedido = _idpedido; 
end;
$$;
 >   DROP FUNCTION public.pedido_detallepedido(_idpedido integer);
       public       postgres    false    4    1            #           1255    16856 g   pedido_insertarpedido(integer, character, character, integer, integer[], smallint[], character varying)    FUNCTION     D  CREATE FUNCTION public.pedido_insertarpedido(_idmesa integer, _situacion character, _tipo character, _idusuario integer, _platos integer[], _cantidades smallint[], _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare _idpedido int; _total numeric := 0.0;
begin
	insert into pedido (idmesa,situacion,tipo,idusuario,total,altausuario,ultimousuario) values
	(_idmesa,_situacion,_tipo,_idusuario,0.1,_usuario,_usuario) returning id into _idpedido;
	
	for i in 1.. ARRAY_LENGTH(_platos,1) loop
		insert into platopedido (idpedido,idplato,cantidad,altausuario,ultimousuario) values
		(_idpedido,_platos[i],_cantidades[i],_usuario,_usuario);
		
		_total = (select _cantidades[i]*precio + _total from plato where id = _platos[i]);
		
	end loop;
	
	update pedido set 
	total = _total
	where id = _idpedido;
	
end;
$$;
 �   DROP FUNCTION public.pedido_insertarpedido(_idmesa integer, _situacion character, _tipo character, _idusuario integer, _platos integer[], _cantidades smallint[], _usuario character varying);
       public       postgres    false    1    4            !           1255    16859     pedido_listarpedidospendientes()    FUNCTION     �  CREATE FUNCTION public.pedido_listarpedidospendientes() RETURNS TABLE(pedido_id integer, pedido_tipo character, pedido_idusuario integer, mesa_numero smallint)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select p.id,tipo,idusuario,m.numero from pedido p
	inner join mesa m on m.id = p.idmesa
	where p.estado = true and situacion = 'P' order by p.ultimafechamodificacion;
end;
$$;
 7   DROP FUNCTION public.pedido_listarpedidospendientes();
       public       postgres    false    1    4                       1255    16863 B   pedido_pagarpedido(integer[], integer, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.pedido_pagarpedido(_pedidos integer[], _numero integer, _idcliente integer, _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare _idcomprobante int; _total numeric := 0.0;
begin
	insert into comprobante (numero,idcliente,total,altausuario,ultimousuario) values
	(_numero,_idcliente,0.1,_usuario,_usuario) returning id into _idcomprobante;
	
	for i in 1.. ARRAY_LENGTH(_pedidos,1) loop
		update pedido set 
		situacion = 'S',
		idcomprobante = _idcomprobante,
		ultimousuario = _usuario,
		ultimafechamodificacion = default
		where id = _pedidos[i];
		
		_total = (SELECT total + _total from pedido where id = _pedidos[i]);
	end loop;
	update comprobante set total = _total where id = _idcomprobante;
end;
$$;
 ~   DROP FUNCTION public.pedido_pagarpedido(_pedidos integer[], _numero integer, _idcliente integer, _usuario character varying);
       public       postgres    false    1    4            �            1255    16777 �   persona_actualizarpersona(integer, character varying, character varying, character varying, character, date, character, character varying, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.persona_actualizarpersona(_idpersona integer, _nombres character varying, _apellidopaterno character varying, _apellidomaterno character varying, _dni character, _fechanacimiento date, _sexo character, _telefono character varying, _celular character varying, _email character varying, _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	
	update persona set 
	nombres = _nombres,
	apellidopaterno = _apellidopaterno,
	apellidomaterno = _apellidomaterno,
	dni = _dni,
	fechanacimiento = _fechanacimiento,
	sexo = _sexo,
	telefono = _telefono,
	celular = _celular,
	email = _email,
	ultimousuario = _usuario,
	ultimafechamodificacion = default
	where id = _idpersona;
	
end;
$$;
 O  DROP FUNCTION public.persona_actualizarpersona(_idpersona integer, _nombres character varying, _apellidopaterno character varying, _apellidomaterno character varying, _dni character, _fechanacimiento date, _sexo character, _telefono character varying, _celular character varying, _email character varying, _usuario character varying);
       public       postgres    false    1    4            �            1255    16776 �   persona_insertarpersona(character varying, character varying, character varying, character, date, character, character varying, character varying, character varying, character varying)    FUNCTION     }  CREATE FUNCTION public.persona_insertarpersona(_nombres character varying, _apellidopaterno character varying, _apellidomaterno character varying, _dni character, _fechanacimiento date, _sexo character, _telefono character varying, _celular character varying, _email character varying, _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	insert into persona (nombres,apellidopaterno,apellidomaterno,dni,fechanacimiento,sexo,telefono,celular,email,altausuario,ultimousuario)
	values
	(_nombres,_apellidopaterno,_apellidomaterno,_dni,_fechanacimiento,_sexo,_telefono,_celular,_email,_usuario,_usuario);
end;
$$;
 9  DROP FUNCTION public.persona_insertarpersona(_nombres character varying, _apellidopaterno character varying, _apellidomaterno character varying, _dni character, _fechanacimiento date, _sexo character, _telefono character varying, _celular character varying, _email character varying, _usuario character varying);
       public       postgres    false    1    4            �            1255    16778    persona_listarpersona()    FUNCTION       CREATE FUNCTION public.persona_listarpersona() RETURNS TABLE(per_id integer, per_nombres character varying, per_apellidopaterno character varying, per_apellidomaterno character varying, per_dni character, per_fechanacimiento date, per_sexo character, per_telefono character varying, per_celular character varying, per_email character varying)
    LANGUAGE plpgsql
    AS $$
begin
	return query 
	select id,nombres,apellidopaterno,apellidomaterno,dni,fechanacimiento,sexo,telefono,celular,email
	from persona where estado;
	
end;
$$;
 .   DROP FUNCTION public.persona_listarpersona();
       public       postgres    false    1    4                       1255    16834 x   plato_actualizarplato(integer, character varying, character varying, text, numeric, integer, boolean, character varying)    FUNCTION       CREATE FUNCTION public.plato_actualizarplato(_idplato integer, _codigo character varying, _nombre character varying, _descripcion text, _precio numeric, _idtipoplato integer, _estado boolean, _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	update plato set 
	codigo = _codigo,
	nombre = _nombre,
	descripcion = _descripcion,
	precio = _precio,
	idtipoplato = _idtipoplato,
	estado = _estado,
	ultimousuario = _usuario,
	ultimafechamodificacion = default
	where id = _idplato;
end;
$$;
 �   DROP FUNCTION public.plato_actualizarplato(_idplato integer, _codigo character varying, _nombre character varying, _descripcion text, _precio numeric, _idtipoplato integer, _estado boolean, _usuario character varying);
       public       postgres    false    1    4                       1255    16833 d   plato_insertarplato(character varying, character varying, text, numeric, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.plato_insertarplato(_codigo character varying, _nombre character varying, _descripcion text, _precio numeric, _idtipoplato integer, _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	insert into plato (codigo,nombre,descripcion,precio,idtipoplato,altausuario,ultimousuario)
	values(_codigo,_nombre,_descripcion,_precio,_idtipoplato,_usuario,_usuario);
end;
$$;
 �   DROP FUNCTION public.plato_insertarplato(_codigo character varying, _nombre character varying, _descripcion text, _precio numeric, _idtipoplato integer, _usuario character varying);
       public       postgres    false    4    1            $           1255    16869    plato_listarplato(integer)    FUNCTION     +  CREATE FUNCTION public.plato_listarplato(_idtipoplato integer) RETURNS TABLE(plato_id integer, plato_codigo character varying, plato_nombre character varying, plato_descripcion text, plato_precio numeric, plato_idtipoplato integer, plato_tipoplato character varying)
    LANGUAGE plpgsql
    AS $$
begin
	return query
	select p.id,p.codigo,p.nombre,p.descripcion,p.precio,tp.id,tp.descripcion
	from plato p 
	inner join tipoplato tp on tp.id = p.idtipoplato
	where p.estado and tp.estado and p.idtipoplato = coalesce(_idtipoplato,p.idtipoplato);
end;
$$;
 >   DROP FUNCTION public.plato_listarplato(_idtipoplato integer);
       public       postgres    false    1    4                       1255    16858 B   platopedido_anularplatopedido(integer, integer, character varying)    FUNCTION     M  CREATE FUNCTION public.platopedido_anularplatopedido(_idpedido integer, _idplato integer, _usuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	update platopedido set
	estado = false,
	ultimafechamodificacion = default,
	ultimousuario = _usuario 
	where idpedido = _idpedido and idplato = _idplato;
end;
$$;
 u   DROP FUNCTION public.platopedido_anularplatopedido(_idpedido integer, _idplato integer, _usuario character varying);
       public       postgres    false    4    1            �            1255    16774 I   rol_actualizarrol(integer, character varying, boolean, character varying)    FUNCTION     [  CREATE FUNCTION public.rol_actualizarrol(_idrol integer, _descripcion character varying, _estado boolean, _usuario character varying) RETURNS void
    LANGUAGE plpgsql STRICT
    AS $$
begin
	update rol set 
	descripcion = _descripcion,
	estado = _estado,
	ultimousuario = _usuario,
	ultimafechamodificacion = default
	where id = _idrol;
end;
$$;
 �   DROP FUNCTION public.rol_actualizarrol(_idrol integer, _descripcion character varying, _estado boolean, _usuario character varying);
       public       postgres    false    1    4            �            1255    16773 5   rol_insertarrol(character varying, character varying)    FUNCTION     	  CREATE FUNCTION public.rol_insertarrol(_descripcion character varying, _usuario character varying) RETURNS void
    LANGUAGE plpgsql STRICT
    AS $$
begin
	insert into rol (descripcion,altausuario,ultimousuario) values 
	(_descripcion,_usuario,_usuario);
end;
$$;
 b   DROP FUNCTION public.rol_insertarrol(_descripcion character varying, _usuario character varying);
       public       postgres    false    1    4            "           1255    16864    rol_listarrol(boolean)    FUNCTION     �  CREATE FUNCTION public.rol_listarrol(_estado boolean) RETURNS TABLE(rol_id integer, rol_descripcion character varying, rol_altausuario character varying, rol_altafecha timestamp without time zone, rol_ultimousuario character varying)
    LANGUAGE plpgsql STRICT
    AS $$
begin
	return query 
	select id, descripcion,altausuario,altafecha,ultimousuario from rol where estado = _estado;
end;
$$;
 5   DROP FUNCTION public.rol_listarrol(_estado boolean);
       public       postgres    false    4    1                       1255    16832    tipoplato_listartipoplato()    FUNCTION       CREATE FUNCTION public.tipoplato_listartipoplato() RETURNS TABLE(tipoplato_id integer, tipoplato_codigo character varying, tipoplato_descripcion character varying)
    LANGUAGE plpgsql
    AS $$
begin
	return query 
	select id,codigo,descripcion from tipoplato 
	where estado;
end;
$$;
 2   DROP FUNCTION public.tipoplato_listartipoplato();
       public       postgres    false    1    4            %           1255    16870 �   usuario_actualizarusuario(integer, integer, character varying, character varying, integer, timestamp without time zone, character varying)    FUNCTION       CREATE FUNCTION public.usuario_actualizarusuario(_idusuario integer, _idpersona integer, _email character varying, _usuario character varying, _idrol integer, _fechaingreso timestamp without time zone, _altausuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	update usuario set 
	idpersona = _idpersona,
	email = _email,
	usuario = _usuario,
	idrol = _idrol,
	fechaingreso = _fechaingreso,
	ultimousuario = _usuario, 
	ultimafechamodificacion = default
	where 
	id = _idusuario;
end;
$$;
 �   DROP FUNCTION public.usuario_actualizarusuario(_idusuario integer, _idpersona integer, _email character varying, _usuario character varying, _idrol integer, _fechaingreso timestamp without time zone, _altausuario character varying);
       public       postgres    false    4    1            &           1255    16871 S   usuario_cambiarcontrasenia(character varying, character varying, character varying)    FUNCTION     	  CREATE FUNCTION public.usuario_cambiarcontrasenia(_usuario character varying, _contraseniaactual character varying, _contrasenianueva character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
	perform id from usuario where usuario = _usuario and contrasenia = crypt(_contraseniaactual,contrasenia);
	if not found then 
		raise exception 'Usuario o contraseña incorrectos.';
	else 
		update usuario 
		set contrasenia = crypt(_contrasenianueva, gen_salt('bf', 8))
		where usuario = _usuario;
	end if;
end;
$$;
 �   DROP FUNCTION public.usuario_cambiarcontrasenia(_usuario character varying, _contraseniaactual character varying, _contrasenianueva character varying);
       public       postgres    false    1    4            �            1255    16784 7   usuario_deshabilitarusuario(integer, character varying)    FUNCTION     6  CREATE FUNCTION public.usuario_deshabilitarusuario(_idusuario integer, _usuario character varying) RETURNS void
    LANGUAGE plpgsql STRICT
    AS $$
begin	
	update usuario set
	fechacese = now(),
	estado = false,
	ultimousuario = _usuario,
	ultimafechamodificacion = default
	where id = _idusuario;	
end;
$$;
 b   DROP FUNCTION public.usuario_deshabilitarusuario(_idusuario integer, _usuario character varying);
       public       postgres    false    1    4            �            1255    16786 4   usuario_habilitarusuario(integer, character varying)    FUNCTION     N  CREATE FUNCTION public.usuario_habilitarusuario(_idusuario integer, _usuario character varying) RETURNS void
    LANGUAGE plpgsql STRICT
    AS $$
begin
		
	update usuario set 
	fechaingreso = now(),
	fechacese = null,
	estado = true,
	ultimousuario = _usuario,
	ultimafechamodificacion = default
	where 
	id = _idusuario;
	
end;
$$;
 _   DROP FUNCTION public.usuario_habilitarusuario(_idusuario integer, _usuario character varying);
       public       postgres    false    1    4            �            1255    16779 �   usuario_insertarusuario(integer, character varying, character varying, character varying, integer, timestamp without time zone, character varying)    FUNCTION       CREATE FUNCTION public.usuario_insertarusuario(_idpersona integer, _email character varying, _usuario character varying, _contrasenia character varying, _idrol integer, _fechaingreso timestamp without time zone, _altausuario character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
	begin
		insert into usuario (idpersona,email,usuario,contrasenia,idrol,fechaingreso,altausuario,ultimousuario)
		values 
		(_idpersona,_email,_usuario,crypt(_contrasenia, gen_salt('bf', 8)),
		 _idrol,_fechaingreso,_altausuario,_altausuario);
	end;
$$;
 �   DROP FUNCTION public.usuario_insertarusuario(_idpersona integer, _email character varying, _usuario character varying, _contrasenia character varying, _idrol integer, _fechaingreso timestamp without time zone, _altausuario character varying);
       public       postgres    false    1    4            �            1255    16782    usuario_listarusuario(boolean)    FUNCTION     �  CREATE FUNCTION public.usuario_listarusuario(_estado boolean) RETURNS TABLE(usu_id integer, usu_idpersona integer, usu_email character varying, usu_usuario character varying, usu_idrol integer, usu_fechaingreso timestamp without time zone, usu_fechacese timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
begin
	return query 
	select id,idpersona,email,usuario,idrol,fechaingreso,fechacese from usuario where estado = _estado;
end;
$$;
 =   DROP FUNCTION public.usuario_listarusuario(_estado boolean);
       public       postgres    false    4    1            �            1255    16789 3   usuario_login(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.usuario_login(_usuario character varying, _contrasenia character varying) RETURNS TABLE(per_nombres character varying, per_apellidopaterno character varying, per_apellidomaterno character varying, per_dni character, usu_usuario character varying, usu_email character varying, rol_descripcion character varying)
    LANGUAGE plpgsql
    AS $$
declare _info record;
begin
	select id, estado into _info from usuario where estado and usuario = _usuario;
	if _info.estado = false then
		raise exception 'Usuario inactivo';
	elsif _info.estado is null then 
		raise exception 'Usuario no existe';
	else
		return query 
		select p.nombres,p.apellidopaterno,p.apellidomaterno,p.dni,u.usuario,u.email,
		r.descripcion from usuario u 
		inner join persona p on p.id = u.idpersona
		inner join rol r on r.id = u.idrol
		where u.usuario = _usuario and contrasenia = crypt(_contrasenia,contrasenia);
		
	end if;
end;
$$;
 `   DROP FUNCTION public.usuario_login(_usuario character varying, _contrasenia character varying);
       public       postgres    false    1    4            �            1259    16762    bitacora    TABLE       CREATE TABLE public.bitacora (
    id bigint NOT NULL,
    tabla character varying(100) NOT NULL,
    anteriorregistro json NOT NULL,
    nuevoregistro json NOT NULL,
    usuario character varying(20) NOT NULL,
    fecha timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.bitacora;
       public         postgres    false    4            �            1259    16760    bitacora_id_seq    SEQUENCE     x   CREATE SEQUENCE public.bitacora_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.bitacora_id_seq;
       public       postgres    false    216    4            �           0    0    bitacora_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.bitacora_id_seq OWNED BY public.bitacora.id;
            public       postgres    false    215            �            1259    16633    cliente    TABLE     w  CREATE TABLE public.cliente (
    id integer NOT NULL,
    idpersona integer NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    altafecha timestamp without time zone DEFAULT now() NOT NULL,
    altausuario character varying(20) NOT NULL,
    ultimafechamodificacion timestamp without time zone DEFAULT now() NOT NULL,
    ultimousuario character varying(20) NOT NULL
);
    DROP TABLE public.cliente;
       public         postgres    false    4            �            1259    16631    cliente_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.cliente_id_seq;
       public       postgres    false    206    4            �           0    0    cliente_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;
            public       postgres    false    205            �            1259    16688    comprobante    TABLE     �  CREATE TABLE public.comprobante (
    id integer NOT NULL,
    numero integer NOT NULL,
    idcliente integer,
    total numeric NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    altafecha timestamp without time zone DEFAULT now() NOT NULL,
    altausuario character varying(20) NOT NULL,
    ultimafechamodificacion timestamp without time zone DEFAULT now() NOT NULL,
    ultimousuario character varying(20) NOT NULL,
    CONSTRAINT ck_comprobantetotal CHECK ((total > 0.0))
);
    DROP TABLE public.comprobante;
       public         postgres    false    4            �            1259    16686    comprobante_id_seq    SEQUENCE     �   CREATE SEQUENCE public.comprobante_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.comprobante_id_seq;
       public       postgres    false    4    212            �           0    0    comprobante_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.comprobante_id_seq OWNED BY public.comprobante.id;
            public       postgres    false    211            �            1259    16620    mesa    TABLE     �  CREATE TABLE public.mesa (
    id integer NOT NULL,
    numero smallint NOT NULL,
    capacidad smallint NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    altafecha timestamp without time zone DEFAULT now() NOT NULL,
    altausuario character varying(20) NOT NULL,
    ultimafechamodificacion timestamp without time zone DEFAULT now() NOT NULL,
    ultimousuario character varying(20) NOT NULL,
    CONSTRAINT ck_mesacapacidad CHECK ((capacidad > 0)),
    CONSTRAINT ck_mesanumero CHECK ((numero > 0))
);
    DROP TABLE public.mesa;
       public         postgres    false    4            �            1259    16618    mesa_id_seq    SEQUENCE     �   CREATE SEQUENCE public.mesa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.mesa_id_seq;
       public       postgres    false    4    204            �           0    0    mesa_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.mesa_id_seq OWNED BY public.mesa.id;
            public       postgres    false    203            �            1259    16710    pedido    TABLE     :  CREATE TABLE public.pedido (
    id integer NOT NULL,
    idmesa integer NOT NULL,
    situacion character(1) DEFAULT 'P'::bpchar NOT NULL,
    tipo character(1) DEFAULT 'M'::bpchar NOT NULL,
    idusuario integer NOT NULL,
    idcomprobante integer,
    total numeric NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    altafecha timestamp without time zone DEFAULT now() NOT NULL,
    altausuario character varying(20) NOT NULL,
    ultimafechamodificacion timestamp without time zone DEFAULT now() NOT NULL,
    ultimousuario character varying(20) NOT NULL,
    CONSTRAINT ck_pedidosituacion CHECK ((situacion = ANY (ARRAY['P'::bpchar, 'C'::bpchar, 'A'::bpchar, 'S'::bpchar]))),
    CONSTRAINT ck_pedidotipo CHECK ((tipo = ANY (ARRAY['M'::bpchar, 'D'::bpchar]))),
    CONSTRAINT ck_pedidototal CHECK ((total > 0.0))
);
    DROP TABLE public.pedido;
       public         postgres    false    4            �            1259    16708    pedido_id_seq    SEQUENCE     �   CREATE SEQUENCE public.pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.pedido_id_seq;
       public       postgres    false    214    4            �           0    0    pedido_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.pedido_id_seq OWNED BY public.pedido.id;
            public       postgres    false    213            �            1259    16568    persona    TABLE     f  CREATE TABLE public.persona (
    id integer NOT NULL,
    nombres character varying(250) NOT NULL,
    apellidopaterno character varying(250),
    apellidomaterno character varying(250),
    dni character(8),
    fechanacimiento date,
    sexo character(1),
    telefono character varying(12),
    celular character varying(12),
    email character varying(100),
    estado boolean DEFAULT true NOT NULL,
    altafecha timestamp without time zone DEFAULT now() NOT NULL,
    altausuario character varying(20) NOT NULL,
    ultimafechamodificacion timestamp without time zone DEFAULT now() NOT NULL,
    ultimousuario character varying(20) NOT NULL,
    CONSTRAINT ck_personadni CHECK ((length(dni) = 8)),
    CONSTRAINT ck_personafechanacimiento CHECK ((fechanacimiento < now())),
    CONSTRAINT ck_personasexo CHECK ((sexo = ANY (ARRAY['M'::bpchar, 'F'::bpchar])))
);
    DROP TABLE public.persona;
       public         postgres    false    4            �            1259    16566    persona_id_seq    SEQUENCE     �   CREATE SEQUENCE public.persona_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.persona_id_seq;
       public       postgres    false    200    4            �           0    0    persona_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.persona_id_seq OWNED BY public.persona.id;
            public       postgres    false    199            �            1259    16664    plato    TABLE     6  CREATE TABLE public.plato (
    id integer NOT NULL,
    codigo character varying(20) NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion text,
    precio numeric NOT NULL,
    idtipoplato integer NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    altafecha timestamp without time zone DEFAULT now() NOT NULL,
    altausuario character varying(20) NOT NULL,
    ultimafechamodificacion timestamp without time zone DEFAULT now() NOT NULL,
    ultimousuario character varying(20) NOT NULL,
    CONSTRAINT ck_platoprecio CHECK ((precio > 0.0))
);
    DROP TABLE public.plato;
       public         postgres    false    4            �            1259    16662    plato_id_seq    SEQUENCE     �   CREATE SEQUENCE public.plato_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.plato_id_seq;
       public       postgres    false    4    210            �           0    0    plato_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.plato_id_seq OWNED BY public.plato.id;
            public       postgres    false    209            �            1259    16836    platopedido    TABLE     �  CREATE TABLE public.platopedido (
    idpedido integer NOT NULL,
    idplato integer NOT NULL,
    cantidad smallint DEFAULT 1 NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    altafecha timestamp without time zone DEFAULT now() NOT NULL,
    altausuario character varying(20) NOT NULL,
    ultimafechamodificacion timestamp without time zone DEFAULT now() NOT NULL,
    ultimousuario character varying(20) NOT NULL,
    CONSTRAINT ck_platopedido_cantidad CHECK ((cantidad > 0))
);
    DROP TABLE public.platopedido;
       public         postgres    false    4            �            1259    16555    rol    TABLE     �  CREATE TABLE public.rol (
    id integer NOT NULL,
    descripcion character varying(250) NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    altafecha timestamp without time zone DEFAULT now() NOT NULL,
    altausuario character varying(20) NOT NULL,
    ultimafechamodificacion timestamp without time zone DEFAULT now() NOT NULL,
    ultimousuario character varying(20) NOT NULL
);
    DROP TABLE public.rol;
       public         postgres    false    4            �            1259    16553 
   rol_id_seq    SEQUENCE     �   CREATE SEQUENCE public.rol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.rol_id_seq;
       public       postgres    false    198    4            �           0    0 
   rol_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE public.rol_id_seq OWNED BY public.rol.id;
            public       postgres    false    197            �            1259    16649 	   tipoplato    TABLE     �  CREATE TABLE public.tipoplato (
    id integer NOT NULL,
    codigo character varying(20) NOT NULL,
    descripcion character varying(20) NOT NULL,
    estado boolean DEFAULT true NOT NULL,
    altafecha timestamp without time zone DEFAULT now() NOT NULL,
    altausuario character varying(20) NOT NULL,
    ultimafechamodificacion timestamp without time zone DEFAULT now() NOT NULL,
    ultimousuario character varying(20) NOT NULL
);
    DROP TABLE public.tipoplato;
       public         postgres    false    4            �            1259    16647    tipoplato_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tipoplato_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.tipoplato_id_seq;
       public       postgres    false    208    4            �           0    0    tipoplato_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.tipoplato_id_seq OWNED BY public.tipoplato.id;
            public       postgres    false    207            �            1259    16591    usuario    TABLE     �  CREATE TABLE public.usuario (
    id integer NOT NULL,
    idpersona integer NOT NULL,
    email character varying(250) NOT NULL,
    usuario character varying(20) NOT NULL,
    contrasenia character varying(250) NOT NULL,
    idrol integer NOT NULL,
    fechaingreso timestamp without time zone NOT NULL,
    fechacese timestamp without time zone,
    estado boolean DEFAULT true NOT NULL,
    altafecha timestamp without time zone DEFAULT now() NOT NULL,
    altausuario character varying(20) NOT NULL,
    ultimafechamodificacion timestamp without time zone DEFAULT now() NOT NULL,
    ultimousuario character varying(20) NOT NULL,
    CONSTRAINT ck_usuariofechas CHECK ((fechaingreso < fechacese))
);
    DROP TABLE public.usuario;
       public         postgres    false    4            �            1259    16589    usuario_id_seq    SEQUENCE     �   CREATE SEQUENCE public.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.usuario_id_seq;
       public       postgres    false    202    4                        0    0    usuario_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;
            public       postgres    false    201            !           2604    16765    bitacora id    DEFAULT     j   ALTER TABLE ONLY public.bitacora ALTER COLUMN id SET DEFAULT nextval('public.bitacora_id_seq'::regclass);
 :   ALTER TABLE public.bitacora ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    215    216    216                       2604    16636 
   cliente id    DEFAULT     h   ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);
 9   ALTER TABLE public.cliente ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    205    206    206                       2604    16691    comprobante id    DEFAULT     p   ALTER TABLE ONLY public.comprobante ALTER COLUMN id SET DEFAULT nextval('public.comprobante_id_seq'::regclass);
 =   ALTER TABLE public.comprobante ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    212    211    212                        2604    16623    mesa id    DEFAULT     b   ALTER TABLE ONLY public.mesa ALTER COLUMN id SET DEFAULT nextval('public.mesa_id_seq'::regclass);
 6   ALTER TABLE public.mesa ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    204    203    204                       2604    16713 	   pedido id    DEFAULT     f   ALTER TABLE ONLY public.pedido ALTER COLUMN id SET DEFAULT nextval('public.pedido_id_seq'::regclass);
 8   ALTER TABLE public.pedido ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    214    213    214            �
           2604    16571 
   persona id    DEFAULT     h   ALTER TABLE ONLY public.persona ALTER COLUMN id SET DEFAULT nextval('public.persona_id_seq'::regclass);
 9   ALTER TABLE public.persona ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    199    200    200                       2604    16667    plato id    DEFAULT     d   ALTER TABLE ONLY public.plato ALTER COLUMN id SET DEFAULT nextval('public.plato_id_seq'::regclass);
 7   ALTER TABLE public.plato ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    209    210    210            �
           2604    16558    rol id    DEFAULT     `   ALTER TABLE ONLY public.rol ALTER COLUMN id SET DEFAULT nextval('public.rol_id_seq'::regclass);
 5   ALTER TABLE public.rol ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    197    198    198            
           2604    16652    tipoplato id    DEFAULT     l   ALTER TABLE ONLY public.tipoplato ALTER COLUMN id SET DEFAULT nextval('public.tipoplato_id_seq'::regclass);
 ;   ALTER TABLE public.tipoplato ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    207    208    208            �
           2604    16594 
   usuario id    DEFAULT     h   ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);
 9   ALTER TABLE public.usuario ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    201    202    202            �          0    16762    bitacora 
   TABLE DATA               ^   COPY public.bitacora (id, tabla, anteriorregistro, nuevoregistro, usuario, fecha) FROM stdin;
    public       postgres    false    216   ��       �          0    16633    cliente 
   TABLE DATA               x   COPY public.cliente (id, idpersona, estado, altafecha, altausuario, ultimafechamodificacion, ultimousuario) FROM stdin;
    public       postgres    false    206   �       �          0    16688    comprobante 
   TABLE DATA               �   COPY public.comprobante (id, numero, idcliente, total, estado, altafecha, altausuario, ultimafechamodificacion, ultimousuario) FROM stdin;
    public       postgres    false    212   H�       �          0    16620    mesa 
   TABLE DATA               }   COPY public.mesa (id, numero, capacidad, estado, altafecha, altausuario, ultimafechamodificacion, ultimousuario) FROM stdin;
    public       postgres    false    204   ��       �          0    16710    pedido 
   TABLE DATA               �   COPY public.pedido (id, idmesa, situacion, tipo, idusuario, idcomprobante, total, estado, altafecha, altausuario, ultimafechamodificacion, ultimousuario) FROM stdin;
    public       postgres    false    214   �       �          0    16568    persona 
   TABLE DATA               �   COPY public.persona (id, nombres, apellidopaterno, apellidomaterno, dni, fechanacimiento, sexo, telefono, celular, email, estado, altafecha, altausuario, ultimafechamodificacion, ultimousuario) FROM stdin;
    public       postgres    false    200   ��       �          0    16664    plato 
   TABLE DATA               �   COPY public.plato (id, codigo, nombre, descripcion, precio, idtipoplato, estado, altafecha, altausuario, ultimafechamodificacion, ultimousuario) FROM stdin;
    public       postgres    false    210   ��       �          0    16836    platopedido 
   TABLE DATA               �   COPY public.platopedido (idpedido, idplato, cantidad, estado, altafecha, altausuario, ultimafechamodificacion, ultimousuario) FROM stdin;
    public       postgres    false    217   ��       �          0    16555    rol 
   TABLE DATA               v   COPY public.rol (id, descripcion, estado, altafecha, altausuario, ultimafechamodificacion, ultimousuario) FROM stdin;
    public       postgres    false    198   u�       �          0    16649 	   tipoplato 
   TABLE DATA               �   COPY public.tipoplato (id, codigo, descripcion, estado, altafecha, altausuario, ultimafechamodificacion, ultimousuario) FROM stdin;
    public       postgres    false    208   �       �          0    16591    usuario 
   TABLE DATA               �   COPY public.usuario (id, idpersona, email, usuario, contrasenia, idrol, fechaingreso, fechacese, estado, altafecha, altausuario, ultimafechamodificacion, ultimousuario) FROM stdin;
    public       postgres    false    202   ��                  0    0    bitacora_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.bitacora_id_seq', 1, false);
            public       postgres    false    215                       0    0    cliente_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.cliente_id_seq', 1, true);
            public       postgres    false    205                       0    0    comprobante_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.comprobante_id_seq', 2, true);
            public       postgres    false    211                       0    0    mesa_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.mesa_id_seq', 5, true);
            public       postgres    false    203                       0    0    pedido_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.pedido_id_seq', 7, true);
            public       postgres    false    213                       0    0    persona_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.persona_id_seq', 5, true);
            public       postgres    false    199                       0    0    plato_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.plato_id_seq', 5, true);
            public       postgres    false    209                       0    0 
   rol_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('public.rol_id_seq', 3, true);
            public       postgres    false    197            	           0    0    tipoplato_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.tipoplato_id_seq', 9, true);
            public       postgres    false    207            
           0    0    usuario_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.usuario_id_seq', 2, true);
            public       postgres    false    201            S           2606    16771    bitacora pk_bitacora 
   CONSTRAINT     R   ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT pk_bitacora PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.bitacora DROP CONSTRAINT pk_bitacora;
       public         postgres    false    216            ?           2606    16641    cliente pk_cliente 
   CONSTRAINT     P   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT pk_cliente PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.cliente DROP CONSTRAINT pk_cliente;
       public         postgres    false    206            M           2606    16700    comprobante pk_comprobante 
   CONSTRAINT     X   ALTER TABLE ONLY public.comprobante
    ADD CONSTRAINT pk_comprobante PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.comprobante DROP CONSTRAINT pk_comprobante;
       public         postgres    false    212            ;           2606    16630    mesa pk_mesa 
   CONSTRAINT     J   ALTER TABLE ONLY public.mesa
    ADD CONSTRAINT pk_mesa PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.mesa DROP CONSTRAINT pk_mesa;
       public         postgres    false    204            Q           2606    16726    pedido pk_pedido 
   CONSTRAINT     N   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pk_pedido PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pk_pedido;
       public         postgres    false    214            -           2606    16582    persona pk_persona 
   CONSTRAINT     P   ALTER TABLE ONLY public.persona
    ADD CONSTRAINT pk_persona PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.persona DROP CONSTRAINT pk_persona;
       public         postgres    false    200            G           2606    16676    plato pk_plato 
   CONSTRAINT     L   ALTER TABLE ONLY public.plato
    ADD CONSTRAINT pk_plato PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.plato DROP CONSTRAINT pk_plato;
       public         postgres    false    210            U           2606    16845    platopedido pk_platopedido 
   CONSTRAINT     g   ALTER TABLE ONLY public.platopedido
    ADD CONSTRAINT pk_platopedido PRIMARY KEY (idpedido, idplato);
 D   ALTER TABLE ONLY public.platopedido DROP CONSTRAINT pk_platopedido;
       public         postgres    false    217    217            )           2606    16563 
   rol pk_rol 
   CONSTRAINT     H   ALTER TABLE ONLY public.rol
    ADD CONSTRAINT pk_rol PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.rol DROP CONSTRAINT pk_rol;
       public         postgres    false    198            A           2606    16657    tipoplato pk_tipoplato 
   CONSTRAINT     T   ALTER TABLE ONLY public.tipoplato
    ADD CONSTRAINT pk_tipoplato PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.tipoplato DROP CONSTRAINT pk_tipoplato;
       public         postgres    false    208            5           2606    16603    usuario pk_usuario 
   CONSTRAINT     P   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT pk_usuario PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.usuario DROP CONSTRAINT pk_usuario;
       public         postgres    false    202            O           2606    16702     comprobante uk_comprobantenumero 
   CONSTRAINT     ]   ALTER TABLE ONLY public.comprobante
    ADD CONSTRAINT uk_comprobantenumero UNIQUE (numero);
 J   ALTER TABLE ONLY public.comprobante DROP CONSTRAINT uk_comprobantenumero;
       public         postgres    false    212            =           2606    16868    mesa uk_mesa_numero 
   CONSTRAINT     P   ALTER TABLE ONLY public.mesa
    ADD CONSTRAINT uk_mesa_numero UNIQUE (numero);
 =   ALTER TABLE ONLY public.mesa DROP CONSTRAINT uk_mesa_numero;
       public         postgres    false    204            /           2606    16586    persona uk_personacelular 
   CONSTRAINT     W   ALTER TABLE ONLY public.persona
    ADD CONSTRAINT uk_personacelular UNIQUE (celular);
 C   ALTER TABLE ONLY public.persona DROP CONSTRAINT uk_personacelular;
       public         postgres    false    200            1           2606    16584    persona uk_personadni 
   CONSTRAINT     O   ALTER TABLE ONLY public.persona
    ADD CONSTRAINT uk_personadni UNIQUE (dni);
 ?   ALTER TABLE ONLY public.persona DROP CONSTRAINT uk_personadni;
       public         postgres    false    200            3           2606    16588    persona uk_personaemail 
   CONSTRAINT     S   ALTER TABLE ONLY public.persona
    ADD CONSTRAINT uk_personaemail UNIQUE (email);
 A   ALTER TABLE ONLY public.persona DROP CONSTRAINT uk_personaemail;
       public         postgres    false    200            I           2606    16678    plato uk_platocodigo 
   CONSTRAINT     Q   ALTER TABLE ONLY public.plato
    ADD CONSTRAINT uk_platocodigo UNIQUE (codigo);
 >   ALTER TABLE ONLY public.plato DROP CONSTRAINT uk_platocodigo;
       public         postgres    false    210            K           2606    16680    plato uk_platonombre 
   CONSTRAINT     Q   ALTER TABLE ONLY public.plato
    ADD CONSTRAINT uk_platonombre UNIQUE (nombre);
 >   ALTER TABLE ONLY public.plato DROP CONSTRAINT uk_platonombre;
       public         postgres    false    210            +           2606    16565    rol uk_roldescripcion 
   CONSTRAINT     W   ALTER TABLE ONLY public.rol
    ADD CONSTRAINT uk_roldescripcion UNIQUE (descripcion);
 ?   ALTER TABLE ONLY public.rol DROP CONSTRAINT uk_roldescripcion;
       public         postgres    false    198            C           2606    16659    tipoplato uk_tipoplatocodigo 
   CONSTRAINT     Y   ALTER TABLE ONLY public.tipoplato
    ADD CONSTRAINT uk_tipoplatocodigo UNIQUE (codigo);
 F   ALTER TABLE ONLY public.tipoplato DROP CONSTRAINT uk_tipoplatocodigo;
       public         postgres    false    208            E           2606    16661 !   tipoplato uk_tipoplatodescripcion 
   CONSTRAINT     c   ALTER TABLE ONLY public.tipoplato
    ADD CONSTRAINT uk_tipoplatodescripcion UNIQUE (descripcion);
 K   ALTER TABLE ONLY public.tipoplato DROP CONSTRAINT uk_tipoplatodescripcion;
       public         postgres    false    208            7           2606    16607    usuario uk_usuario 
   CONSTRAINT     P   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT uk_usuario UNIQUE (usuario);
 <   ALTER TABLE ONLY public.usuario DROP CONSTRAINT uk_usuario;
       public         postgres    false    202            9           2606    16605    usuario uk_usuarioemail 
   CONSTRAINT     S   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT uk_usuarioemail UNIQUE (email);
 A   ALTER TABLE ONLY public.usuario DROP CONSTRAINT uk_usuarioemail;
       public         postgres    false    202            X           2606    16642    cliente fk_clienteidpersona    FK CONSTRAINT     ~   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT fk_clienteidpersona FOREIGN KEY (idpersona) REFERENCES public.persona(id);
 E   ALTER TABLE ONLY public.cliente DROP CONSTRAINT fk_clienteidpersona;
       public       postgres    false    200    2861    206            Z           2606    16703 #   comprobante fk_comprobanteidcliente    FK CONSTRAINT     �   ALTER TABLE ONLY public.comprobante
    ADD CONSTRAINT fk_comprobanteidcliente FOREIGN KEY (idcliente) REFERENCES public.cliente(id);
 M   ALTER TABLE ONLY public.comprobante DROP CONSTRAINT fk_comprobanteidcliente;
       public       postgres    false    206    212    2879            ]           2606    16737    pedido fk_pedidoidcomprobante    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pedidoidcomprobante FOREIGN KEY (idcomprobante) REFERENCES public.comprobante(id);
 G   ALTER TABLE ONLY public.pedido DROP CONSTRAINT fk_pedidoidcomprobante;
       public       postgres    false    2893    214    212            [           2606    16727    pedido fk_pedidoidmesa    FK CONSTRAINT     s   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pedidoidmesa FOREIGN KEY (idmesa) REFERENCES public.mesa(id);
 @   ALTER TABLE ONLY public.pedido DROP CONSTRAINT fk_pedidoidmesa;
       public       postgres    false    214    204    2875            \           2606    16732    pedido fk_pedidoidusuario    FK CONSTRAINT     |   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pedidoidusuario FOREIGN KEY (idusuario) REFERENCES public.usuario(id);
 C   ALTER TABLE ONLY public.pedido DROP CONSTRAINT fk_pedidoidusuario;
       public       postgres    false    2869    214    202            Y           2606    16681    plato fk_platoidtipoplato    FK CONSTRAINT     �   ALTER TABLE ONLY public.plato
    ADD CONSTRAINT fk_platoidtipoplato FOREIGN KEY (idtipoplato) REFERENCES public.tipoplato(id);
 C   ALTER TABLE ONLY public.plato DROP CONSTRAINT fk_platoidtipoplato;
       public       postgres    false    2881    208    210            ^           2606    16846 "   platopedido fk_platopedidoidpedido    FK CONSTRAINT     �   ALTER TABLE ONLY public.platopedido
    ADD CONSTRAINT fk_platopedidoidpedido FOREIGN KEY (idpedido) REFERENCES public.pedido(id);
 L   ALTER TABLE ONLY public.platopedido DROP CONSTRAINT fk_platopedidoidpedido;
       public       postgres    false    2897    217    214            _           2606    16851 !   platopedido fk_platopedidoidplato    FK CONSTRAINT     �   ALTER TABLE ONLY public.platopedido
    ADD CONSTRAINT fk_platopedidoidplato FOREIGN KEY (idplato) REFERENCES public.plato(id);
 K   ALTER TABLE ONLY public.platopedido DROP CONSTRAINT fk_platopedidoidplato;
       public       postgres    false    2887    210    217            V           2606    16608    usuario fk_usuarioidpersona    FK CONSTRAINT     ~   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuarioidpersona FOREIGN KEY (idpersona) REFERENCES public.persona(id);
 E   ALTER TABLE ONLY public.usuario DROP CONSTRAINT fk_usuarioidpersona;
       public       postgres    false    200    2861    202            W           2606    16613    usuario fk_usuarioidrol    FK CONSTRAINT     r   ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT fk_usuarioidrol FOREIGN KEY (idrol) REFERENCES public.rol(id);
 A   ALTER TABLE ONLY public.usuario DROP CONSTRAINT fk_usuarioidrol;
       public       postgres    false    202    198    2857            �      x������ � �      �   7   x�3�4�,�420��5��54T00�"cS=#sss33΢����D"�p��qqq ���      �   A   x�3�4�4�422׳4�,�420��5��54T00�20�25�377077�,JL�/.I$B	W� =f      �   j   x����	�0F�4���/˶�Yz	 �f
9Jc����d��h,Z�bh%�EE��{�냄3���R�#b��a��va���&;1S�5����~	3@s4�      �   �   x��̱�0����@-۱�$+3,�]*$V$����CaAw��3�8@1��(K��N";�nϒ��q[����l'>J��Yߓ��q�]\���_�nA������st/����u$�Z�����&��y����u;�      �     x����n�0��}�T���䴊M�J'ƑKD���6(�x����Cc"'G���,��X�+(f�۪��.�^���q͐���԰C�c�;��M�� ��2n��#�f�X$�ⱜ/�/Gߧ3wa��a�������nN`̕+g�G�Պ�̕�U������qnσ)�S�a��BK��&��C��xϊ�H���ň�C��=�������II�[�xV�II�j�/n1�st�gRs����H�Β$��Wwe      �      x���Aj�0D�ߧ��з,K�.�]�� �E!'2�S�ަg�r�ʡiB�B7�3̛Q+.`�R|C��)d󍴿HB2�A�5'3�z�%R�ղ��i%�n �b�?,�l��n�q^ƈ�y�.���<q�1�ೳ�r�O���O`��ǃ͘�+���rl<.v�����̘�ȩ#�L�M�� �R3ɕ��\�e��=n-���L!�Mq�T���H#�B��T���}��ѧ2�y
x(�S\8}J��ձ?;��ܷm:!X�����_ ����5t��5����֘m      �   v   x���K
�0��u�^�Е���Y܈f�?�Y�ࢡ�?�	%�)I�f�30)���D[H�|����ۋ$��Uˎ�S�h�/���كv��Zv���pѲv,�L�A�K�FW��C?�<      �   �   x��α
�0F�9y��@�͟���[�:����K���#�����p��m�ݼL�'�)�M5���Al��x�'�4T_�2�{�k
�x'�L
!1�u=_n��M� &!�}�T>�<,�h��4o�=��_��>bܓ'���t�8      �   �   x���M
� �uz
/Т��gv�Jl��2ǘ�3�	f#d|��Spf���=8�o!�Z���s+�P��=�2����F3�!G<	�EDA>���ݳ�C�d���[�X�D����b�包7�A��Dg�5���V���#a1�U��	r��*�g�f�aDW�\�\�RF���T���i����	      �      x���Mo�@��˯�����]X>N*m"��Ʀ
�B�"T٥}��MO�:3��3QԦ�Z�tؾ	�7��& ��ؚ���1ٮ�6���}.�U�Ŏ�D'U&��\����؀]��Q��@,�Z*1]�\�c�[�8ZGH��G�~�o@���,�(�RtM]�CZ���p�D�|��j��;��vTF�	��΃MnǞ��lA���-�f6�T��:!*�uߤ�r��\|P)s�t۰��{ᝊ���Ɗ�|ׯf�     