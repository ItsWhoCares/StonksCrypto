--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1
-- Dumped by pg_dump version 15.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: next_auth; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA next_auth;


ALTER SCHEMA next_auth OWNER TO postgres;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO supabase_admin;

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: pgtle; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA pgtle;


ALTER SCHEMA pgtle OWNER TO supabase_admin;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  schema_is_cron bool;
BEGIN
  schema_is_cron = (
    SELECT n.nspname = 'cron'
    FROM pg_event_trigger_ddl_commands() AS ev
    LEFT JOIN pg_catalog.pg_namespace AS n
      ON ev.objid = n.oid
  );

  IF schema_is_cron
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;

  END IF;

END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: uid(); Type: FUNCTION; Schema: next_auth; Owner: postgres
--

CREATE FUNCTION next_auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select
    coalesce(
        nullif(current_setting('request.jwt.claim.sub', true), ''),
        (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
    )::uuid
$$;


ALTER FUNCTION next_auth.uid() OWNER TO postgres;

--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
    select string_to_array(name, '/') into _parts;
    select _parts[array_length(_parts,1)] into _filename;
    -- @todo return the last part instead of 2
    return split_part(_filename, '.', 2);
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(regexp_split_to_array(objects.name, ''/''), 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(regexp_split_to_array(objects.name, ''/''), 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: secrets_encrypt_secret_secret(); Type: FUNCTION; Schema: vault; Owner: supabase_admin
--

CREATE FUNCTION vault.secrets_encrypt_secret_secret() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		        new.secret = CASE WHEN new.secret IS NULL THEN NULL ELSE
			CASE WHEN new.key_id IS NULL THEN NULL ELSE pg_catalog.encode(
			  pgsodium.crypto_aead_det_encrypt(
				pg_catalog.convert_to(new.secret, 'utf8'),
				pg_catalog.convert_to((new.id::text || new.description::text || new.created_at::text || new.updated_at::text)::text, 'utf8'),
				new.key_id::uuid,
				new.nonce
			  ),
				'base64') END END;
		RETURN new;
		END;
		$$;


ALTER FUNCTION vault.secrets_encrypt_secret_secret() OWNER TO supabase_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for oauth provider logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    from_ip_address inet,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: accounts; Type: TABLE; Schema: next_auth; Owner: postgres
--

CREATE TABLE next_auth.accounts (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    type text NOT NULL,
    provider text NOT NULL,
    "providerAccountId" text NOT NULL,
    refresh_token text,
    access_token text,
    expires_at bigint,
    token_type text,
    scope text,
    id_token text,
    session_state text,
    oauth_token_secret text,
    oauth_token text,
    "userId" uuid
);


ALTER TABLE next_auth.accounts OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: next_auth; Owner: postgres
--

CREATE TABLE next_auth.sessions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    expires timestamp with time zone NOT NULL,
    "sessionToken" text NOT NULL,
    "userId" uuid
);


ALTER TABLE next_auth.sessions OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: next_auth; Owner: postgres
--

CREATE TABLE next_auth.users (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name text,
    email text,
    "emailVerified" timestamp with time zone,
    image text
);


ALTER TABLE next_auth.users OWNER TO postgres;

--
-- Name: verification_tokens; Type: TABLE; Schema: next_auth; Owner: postgres
--

CREATE TABLE next_auth.verification_tokens (
    identifier text,
    token text NOT NULL,
    expires timestamp with time zone NOT NULL
);


ALTER TABLE next_auth.verification_tokens OWNER TO postgres;

--
-- Name: Coins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Coins" (
    "Symbol" text NOT NULL,
    "CoinName" text,
    "Algorithm" text,
    "IsTrading" boolean,
    "ProofType" text,
    "TotalCoinsMined" double precision,
    "TotalCoinSupply" text
);


ALTER TABLE public."Coins" OWNER TO postgres;

--
-- Name: bookmarks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookmarks (
    "userID" uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "coinUUID" text NOT NULL
);


ALTER TABLE public.bookmarks OWNER TO postgres;

--
-- Name: buyTransaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."buyTransaction" (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "userID" uuid,
    "coinUUID" text,
    "coinPrice" double precision
);


ALTER TABLE public."buyTransaction" OWNER TO postgres;

--
-- Name: portfolio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.portfolio (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    "userID" uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "coinUUID" text NOT NULL,
    "buyID" uuid NOT NULL
);


ALTER TABLE public.portfolio OWNER TO postgres;

--
-- Name: sellTransaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."sellTransaction" (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "buyID" uuid NOT NULL,
    "userID" uuid NOT NULL,
    "coinUUID" text NOT NULL,
    "coinPrice" double precision NOT NULL
);


ALTER TABLE public."sellTransaction" OWNER TO postgres;

--
-- Name: userData; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."userData" (
    "userID" uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    balance double precision
);


ALTER TABLE public."userData" OWNER TO postgres;

--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[]
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: decrypted_secrets; Type: VIEW; Schema: vault; Owner: supabase_admin
--

CREATE VIEW vault.decrypted_secrets AS
 SELECT secrets.id,
    secrets.name,
    secrets.description,
    secrets.secret,
        CASE
            WHEN (secrets.secret IS NULL) THEN NULL::text
            ELSE
            CASE
                WHEN (secrets.key_id IS NULL) THEN NULL::text
                ELSE convert_from(pgsodium.crypto_aead_det_decrypt(decode(secrets.secret, 'base64'::text), convert_to(((((secrets.id)::text || secrets.description) || (secrets.created_at)::text) || (secrets.updated_at)::text), 'utf8'::name), secrets.key_id, secrets.nonce), 'utf8'::name)
            END
        END AS decrypted_secret,
    secrets.key_id,
    secrets.nonce,
    secrets.created_at,
    secrets.updated_at
   FROM vault.secrets;


ALTER TABLE vault.decrypted_secrets OWNER TO supabase_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	aa8aeb87-0bbf-49bf-84a9-88dd967999c8	{"action":"user_confirmation_requested","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"user","traits":{"provider":"email"}}	2023-03-23 05:50:31.822017+00	
00000000-0000-0000-0000-000000000000	343956c7-afab-40f8-8146-dc26054d968c	{"action":"user_signedup","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"team"}	2023-03-23 05:50:47.61989+00	
00000000-0000-0000-0000-000000000000	91222159-1f4a-480b-ac48-fa36f6e7a720	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-23 07:44:01.414459+00	
00000000-0000-0000-0000-000000000000	cf4599bc-89a9-4d08-ad4f-08048bb020e6	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-23 07:44:01.415173+00	
00000000-0000-0000-0000-000000000000	54057fac-01a8-40b5-8d28-7f97446cc918	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-23 07:44:01.486502+00	
00000000-0000-0000-0000-000000000000	ca95ffd2-5660-42cc-ae96-96077a44d66e	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-26 09:05:14.539108+00	
00000000-0000-0000-0000-000000000000	5dba41c9-0c5c-4373-9602-525a1c16590e	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-26 09:05:14.541326+00	
00000000-0000-0000-0000-000000000000	0c8276f9-b631-4e97-b5af-45500a3bd512	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-26 09:05:14.571695+00	
00000000-0000-0000-0000-000000000000	a2f6388e-2ee0-45b3-8f48-dd24bad1ada7	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-26 10:10:34.376535+00	
00000000-0000-0000-0000-000000000000	4f805ee9-22c4-4143-a3fe-55d613c10b29	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-26 10:10:34.377366+00	
00000000-0000-0000-0000-000000000000	f8e12000-1469-4154-a94b-a8956ca53e81	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-26 10:10:34.393691+00	
00000000-0000-0000-0000-000000000000	a30ba99e-dc79-43c5-9e48-5801605d2f1c	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 14:03:55.042658+00	
00000000-0000-0000-0000-000000000000	e65d116d-35da-48c1-afe1-b16badab1ead	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 14:03:55.043389+00	
00000000-0000-0000-0000-000000000000	0d0a0456-a2f1-4407-a649-53b7b8948098	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 14:03:55.069582+00	
00000000-0000-0000-0000-000000000000	4557db4f-7443-4ba1-a5c1-362c78c68259	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 15:10:50.623794+00	
00000000-0000-0000-0000-000000000000	c5deaa6a-8e04-4cce-8a83-67b4842a78ef	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 15:10:50.624548+00	
00000000-0000-0000-0000-000000000000	d5efd32f-ff64-4eef-83b1-750f1b13b783	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 15:10:50.633601+00	
00000000-0000-0000-0000-000000000000	3cf28e2d-b515-43c0-ac37-c1eab6a389d1	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 15:10:50.634265+00	
00000000-0000-0000-0000-000000000000	e89d457b-d64a-404e-b29f-cb9ee05da50d	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 16:10:27.589554+00	
00000000-0000-0000-0000-000000000000	fd23f972-e02e-441a-8bda-d29644ee7deb	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 16:10:27.589179+00	
00000000-0000-0000-0000-000000000000	f2440e60-6e47-41a1-bc6e-9a73dbd6b967	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 16:10:27.590724+00	
00000000-0000-0000-0000-000000000000	02e8d58c-d5a6-4290-9ad9-72829f0fb962	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 16:10:27.592222+00	
00000000-0000-0000-0000-000000000000	997ae957-3979-4193-ae89-cca9523a7aa6	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 16:10:27.6051+00	
00000000-0000-0000-0000-000000000000	05047c37-4f80-4ade-bde2-71c69bd1111c	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 16:10:27.615585+00	
00000000-0000-0000-0000-000000000000	1d60d445-e8b9-4444-834e-180dfc0572a7	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 16:10:27.636177+00	
00000000-0000-0000-0000-000000000000	a411cf4c-76d8-4b5f-9c62-b3466dac6e6b	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 16:10:27.646812+00	
00000000-0000-0000-0000-000000000000	2a929ff9-3143-4370-806d-57dc35db7008	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 16:10:27.648343+00	
00000000-0000-0000-0000-000000000000	148eddfc-bd36-4008-a215-b29b12856b2c	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-27 16:10:27.66278+00	
00000000-0000-0000-0000-000000000000	8155f6ae-8a94-4563-af0f-2ae826451d2f	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-28 14:40:45.315923+00	
00000000-0000-0000-0000-000000000000	3d4e1b0e-e26b-406f-8b16-898a0b56f4d6	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-28 14:40:45.316855+00	
00000000-0000-0000-0000-000000000000	007dff17-243c-466c-903d-ad5ff0b32900	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","log_type":"token"}	2023-03-28 14:40:45.332093+00	
00000000-0000-0000-0000-000000000000	cd175e42-9bf0-4157-8352-e01d54e3b701	{"action":"user_recovery_requested","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"user"}	2023-04-07 13:06:03.124142+00	
00000000-0000-0000-0000-000000000000	466ca6b9-a7fe-4ad5-a3d8-df8bf10b4655	{"action":"user_recovery_requested","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"user"}	2023-04-07 13:07:28.544091+00	
00000000-0000-0000-0000-000000000000	f3b4b787-a036-4e40-a3ab-bc0344cac565	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-07 13:08:40.916247+00	
00000000-0000-0000-0000-000000000000	628e59e5-0639-461a-b187-b1a2900f3307	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-07 13:10:40.674474+00	
00000000-0000-0000-0000-000000000000	382ed210-4db1-4df5-877d-161b73127aa7	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-08 14:55:59.586056+00	
00000000-0000-0000-0000-000000000000	f356c6fb-9036-487e-bb8a-6566faaecb7b	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-08 14:55:59.586925+00	
00000000-0000-0000-0000-000000000000	62f9e0fd-de1e-4766-8aa4-ea283232a669	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-08 14:55:59.593057+00	
00000000-0000-0000-0000-000000000000	67f22609-e26a-4eba-9f78-a58f3751fb0d	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-08 14:55:59.593906+00	
00000000-0000-0000-0000-000000000000	01cffd22-f73e-4b15-ae51-81400741c2b3	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-08 14:55:59.700665+00	
00000000-0000-0000-0000-000000000000	4be14436-f821-4a1d-b66e-65952cf50eff	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-08 15:55:59.927207+00	
00000000-0000-0000-0000-000000000000	90a9f2c6-06ba-43d7-9648-9918f4724fba	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-08 15:55:59.927787+00	
00000000-0000-0000-0000-000000000000	cf4c4ea7-4825-4ab8-8aeb-d58dbd0d2f3a	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-08 15:56:00.438376+00	
00000000-0000-0000-0000-000000000000	ca60eed6-8b65-45d6-9dca-6d345f5253cb	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-08 17:09:46.446202+00	
00000000-0000-0000-0000-000000000000	2ff5385f-cce5-488b-80a1-14be6e8b997e	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-08 17:09:46.446725+00	
00000000-0000-0000-0000-000000000000	58521b6e-9383-4bfb-83bb-b55942deea1a	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-08 17:09:46.462032+00	
00000000-0000-0000-0000-000000000000	7270d4b4-d87c-4db7-b3f8-7f05adc4bd25	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-08 17:09:46.613248+00	
00000000-0000-0000-0000-000000000000	54c04dd4-6c73-40a3-8003-037bb0e77779	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-09 12:01:45.588149+00	
00000000-0000-0000-0000-000000000000	eb20084f-2bb2-4245-9e4d-9f211de0762a	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-09 12:01:45.588442+00	
00000000-0000-0000-0000-000000000000	9433f047-0a59-4c20-afe1-b8d96fb8fc70	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-09 12:01:45.589049+00	
00000000-0000-0000-0000-000000000000	9ea3c269-ce12-46cf-a3c0-d96b5c63fa42	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-09 12:01:45.589149+00	
00000000-0000-0000-0000-000000000000	36188559-5c89-4375-9dbd-264775dfd1ef	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-09 13:58:13.56187+00	
00000000-0000-0000-0000-000000000000	8c73a8ca-d3c8-49a4-b868-b09b02b8ccba	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-09 13:58:13.562655+00	
00000000-0000-0000-0000-000000000000	df853788-79f0-4f29-8480-59f7685f0ab8	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-09 13:58:13.571257+00	
00000000-0000-0000-0000-000000000000	a8d9a193-7184-4fa8-afc9-d7868ce3fe31	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-09 14:58:12.834615+00	
00000000-0000-0000-0000-000000000000	571c3d8d-90ec-40dc-b4f9-000a0d5fe511	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-09 14:58:12.835226+00	
00000000-0000-0000-0000-000000000000	4b46050a-1b07-4eb5-988f-b349e14827c6	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-09 14:58:12.930803+00	
00000000-0000-0000-0000-000000000000	99e26555-83d9-40cd-a969-4744b9067605	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-10 11:31:17.506666+00	
00000000-0000-0000-0000-000000000000	78f0e87b-70a3-4e3b-8c5f-fdc74717f0f7	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-10 11:31:17.507854+00	
00000000-0000-0000-0000-000000000000	93e9bfc0-ed81-48d9-a358-60abb67230b8	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-10 11:31:17.556623+00	
00000000-0000-0000-0000-000000000000	ab9fe2ef-04ca-4bb3-b4ae-3454b9a16d82	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-10 12:31:50.602728+00	
00000000-0000-0000-0000-000000000000	31639690-77d5-4847-9676-cd76c5803824	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-10 12:31:50.603357+00	
00000000-0000-0000-0000-000000000000	e5ffaf0c-5cb5-4386-9e32-7166b816d218	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-10 12:31:50.697293+00	
00000000-0000-0000-0000-000000000000	b3be528e-edfd-4cc6-b3be-b31d283ecc1f	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-10 13:31:45.741328+00	
00000000-0000-0000-0000-000000000000	c4fac1fe-973c-4509-b77c-cb99403930a5	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-10 13:31:45.741927+00	
00000000-0000-0000-0000-000000000000	d2da86aa-20d2-41ff-a6a8-8d8606862ae3	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-10 13:31:45.874545+00	
00000000-0000-0000-0000-000000000000	b63ce38c-9930-446d-9ffd-8aeb0b29f0e9	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-12 06:09:42.922333+00	
00000000-0000-0000-0000-000000000000	cbcdd0d6-f7a1-4d4a-a005-a259be4009e3	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-12 06:09:42.923265+00	
00000000-0000-0000-0000-000000000000	7de11e39-ec50-4ed5-bacc-d7ddff91bd3e	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-12 06:09:42.928871+00	
00000000-0000-0000-0000-000000000000	19c2c4f8-aaba-45ca-a8fe-d9b4cd20d01c	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-12 06:09:42.929885+00	
00000000-0000-0000-0000-000000000000	6b27cbb6-9552-4fb4-86fb-56f57b04be10	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-12 06:09:43.023165+00	
00000000-0000-0000-0000-000000000000	e70af24b-608d-4b9e-a2b7-04c27723c717	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-12 07:13:27.457456+00	
00000000-0000-0000-0000-000000000000	98e2035d-68cd-489c-b458-42ae90333407	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-12 07:13:27.458533+00	
00000000-0000-0000-0000-000000000000	a9ae8cdb-a2c6-480a-89af-c13b76be7283	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-12 07:13:27.708857+00	
00000000-0000-0000-0000-000000000000	588134ad-ff1a-46a2-92df-cacb746ff66b	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-12 08:13:04.288359+00	
00000000-0000-0000-0000-000000000000	8ab6598b-6fc6-43da-ad16-edfe87cfe926	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-12 08:13:04.289235+00	
00000000-0000-0000-0000-000000000000	2e5a7acf-8e09-46f6-a0a6-3ee2bcc9edb7	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-12 08:13:04.306936+00	
00000000-0000-0000-0000-000000000000	b987c25c-4f53-4486-97fc-84c9836d61eb	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-14 13:02:49.870026+00	
00000000-0000-0000-0000-000000000000	2976bfed-d345-4670-8707-685857057367	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.344025+00	
00000000-0000-0000-0000-000000000000	649a06f5-75cb-4cc8-87ab-af45410f9346	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.344764+00	
00000000-0000-0000-0000-000000000000	23179dd3-0911-4454-aaac-8acf9eb19a56	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.359091+00	
00000000-0000-0000-0000-000000000000	7c511372-fb8c-4e62-bf89-dd9afb402bc7	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.413468+00	
00000000-0000-0000-0000-000000000000	3a4dddb4-d5ac-46d8-8041-74f446146308	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.426602+00	
00000000-0000-0000-0000-000000000000	95c8921f-6708-4185-b85d-4a48816d8044	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.477541+00	
00000000-0000-0000-0000-000000000000	162436e2-845e-470c-b50b-84bc19a151ca	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.350901+00	
00000000-0000-0000-0000-000000000000	713facfd-807b-4297-aaea-99f198990f88	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.352018+00	
00000000-0000-0000-0000-000000000000	cbb4ea38-259a-4afc-ad30-cda76a953c27	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.363558+00	
00000000-0000-0000-0000-000000000000	3c9a31f7-32df-4467-9e24-8774d2d4ff00	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.401868+00	
00000000-0000-0000-0000-000000000000	526cdccd-16b5-4219-a9b6-54704de812e9	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.413808+00	
00000000-0000-0000-0000-000000000000	3d094b59-36a9-4c0b-9324-6d7bf0b691f1	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.449958+00	
00000000-0000-0000-0000-000000000000	3d5d5fe5-35cd-48df-bbc2-874c61592dea	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.47616+00	
00000000-0000-0000-0000-000000000000	ac62b157-159c-4f7b-a3c0-a9512539b864	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.476537+00	
00000000-0000-0000-0000-000000000000	22434f05-777f-4451-9861-41dfb00f2eff	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.484167+00	
00000000-0000-0000-0000-000000000000	79d9ce82-2884-43f2-b045-935c7fc0c0d1	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.490911+00	
00000000-0000-0000-0000-000000000000	3fd984a1-91d0-4935-a53b-2978d09a63ac	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.50207+00	
00000000-0000-0000-0000-000000000000	4434f1f6-a498-4780-88aa-5a00be937437	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.503156+00	
00000000-0000-0000-0000-000000000000	d6f3a2e2-29be-4935-a515-36899a16810f	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.547686+00	
00000000-0000-0000-0000-000000000000	6471f416-9302-48f0-ba47-3e8cbbd8c0a5	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.567533+00	
00000000-0000-0000-0000-000000000000	30e70c5d-10d6-4558-b701-00a6a8a3e21c	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:39.613454+00	
00000000-0000-0000-0000-000000000000	c6827505-f488-40d3-937b-7c57bb1827c3	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 14:03:40.108139+00	
00000000-0000-0000-0000-000000000000	43706f38-1c29-402b-9ac5-fa3e919174fb	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 15:22:49.57428+00	
00000000-0000-0000-0000-000000000000	b308ed0a-97e3-4586-a4b7-6585df8f646c	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 15:22:49.575048+00	
00000000-0000-0000-0000-000000000000	5b3c7879-f192-4cb3-af78-6c04b09284ac	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 15:22:49.604247+00	
00000000-0000-0000-0000-000000000000	9ecc9d7a-5904-45d3-bca2-7374c34a01c4	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 16:33:39.400643+00	
00000000-0000-0000-0000-000000000000	505bbcf8-9e0d-4ab1-95ae-f65b525806ce	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 16:33:39.401239+00	
00000000-0000-0000-0000-000000000000	2bc4e08d-1eac-40dd-8652-82b61f5b9a86	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 16:33:39.418561+00	
00000000-0000-0000-0000-000000000000	89134a23-9870-4f68-be0d-8de865772146	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.669683+00	
00000000-0000-0000-0000-000000000000	8fe7cd69-418e-4e28-9eb5-de9adb55e92b	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.670509+00	
00000000-0000-0000-0000-000000000000	833f25d7-bb1b-449e-bfd1-6a0bdac287ea	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.678087+00	
00000000-0000-0000-0000-000000000000	0baf15e0-d92f-412f-b261-1708f007e42e	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.685603+00	
00000000-0000-0000-0000-000000000000	ab4368ee-7039-4f64-bcda-94275c65bcf1	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.689303+00	
00000000-0000-0000-0000-000000000000	bc866686-bbe1-4a82-be8c-ac6002744967	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.714975+00	
00000000-0000-0000-0000-000000000000	23bf270e-d1e2-4e61-be1e-9beb68f1066f	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.723777+00	
00000000-0000-0000-0000-000000000000	b3d77633-0cce-4652-9fb6-4232d735698f	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.726157+00	
00000000-0000-0000-0000-000000000000	088fa33c-a30e-4375-8d76-0b656aee7ba6	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.739765+00	
00000000-0000-0000-0000-000000000000	97f8e524-8dd1-4352-a59c-ba58b88b04e5	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.765625+00	
00000000-0000-0000-0000-000000000000	6d7c9e93-acd5-4f86-b9a9-6d7c9f035bc4	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.769302+00	
00000000-0000-0000-0000-000000000000	27beac1c-7a8f-44c1-a309-3ddfef6b2d59	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.770604+00	
00000000-0000-0000-0000-000000000000	c9535dc4-9b6a-4ea9-8b1f-e25f82901964	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.773408+00	
00000000-0000-0000-0000-000000000000	a8d8ced0-7906-491d-bdf0-f152b24f2251	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.801234+00	
00000000-0000-0000-0000-000000000000	0e7e7ba6-8851-4f21-ae28-383309a2d0b5	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.802815+00	
00000000-0000-0000-0000-000000000000	c27e9f3f-411b-49c1-8529-a7f48efa8e12	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.816866+00	
00000000-0000-0000-0000-000000000000	bb8ee044-7a7a-42a7-8277-499d7f6dbfa2	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.832276+00	
00000000-0000-0000-0000-000000000000	736a4734-82f0-40bd-bd85-015f1eee7049	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.8447+00	
00000000-0000-0000-0000-000000000000	7da8f5c3-fa69-4850-8e6f-ec74e83528fe	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.885782+00	
00000000-0000-0000-0000-000000000000	f7214594-e831-45e7-a40f-eaf6bd0d831b	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.901915+00	
00000000-0000-0000-0000-000000000000	4abdc62d-8082-4898-9d10-a39cc8c2b8d9	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.925605+00	
00000000-0000-0000-0000-000000000000	8a19acba-326d-49b1-86cd-e4f8ad334db4	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.938714+00	
00000000-0000-0000-0000-000000000000	3a26ac5f-112f-4563-853d-006b0a38794f	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.946244+00	
00000000-0000-0000-0000-000000000000	8bb08d1d-a841-4b74-bbd0-a13f7e28116d	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.77861+00	
00000000-0000-0000-0000-000000000000	627e7a02-a638-4906-ad71-c203a1df57dd	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.792191+00	
00000000-0000-0000-0000-000000000000	a1f94140-31ee-40ab-a1e7-be60db93ad09	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.801265+00	
00000000-0000-0000-0000-000000000000	4f620a3d-ae3e-4ac4-b4f9-9c31cf5c8c89	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.797436+00	
00000000-0000-0000-0000-000000000000	9dd3073f-f120-4fcd-98b2-38b66458c7a3	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.814206+00	
00000000-0000-0000-0000-000000000000	6ec0ec7a-357d-4956-8820-186b7da5bd07	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.82545+00	
00000000-0000-0000-0000-000000000000	740bb323-562f-4e16-8de7-86122d09e94e	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.936049+00	
00000000-0000-0000-0000-000000000000	9677727b-752b-45c1-bd13-38dcb2814b20	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-14 17:33:20.95038+00	
00000000-0000-0000-0000-000000000000	473a0bd6-dede-4196-a5a0-d6d7af4d5635	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 11:42:02.012937+00	
00000000-0000-0000-0000-000000000000	0962bb2f-3fcc-466e-9d3b-cd9809139bb1	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 11:42:02.013763+00	
00000000-0000-0000-0000-000000000000	da533f21-2c65-4eeb-a96a-ac86b285df9d	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 11:42:02.042531+00	
00000000-0000-0000-0000-000000000000	4c54b920-d684-4a8a-a1fa-467d716e19ee	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-15 11:42:02.361893+00	
00000000-0000-0000-0000-000000000000	8b7902dc-35e0-41c1-995a-907afcd9357e	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 13:40:53.262435+00	
00000000-0000-0000-0000-000000000000	2b2a5685-c505-463e-bde4-9aecaab6a259	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 13:40:53.262998+00	
00000000-0000-0000-0000-000000000000	1ebda00f-4742-40e5-b757-e460ea0c17fb	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 13:40:53.319271+00	
00000000-0000-0000-0000-000000000000	4281271e-56aa-44dd-a2ba-ba80332cc1f1	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 14:40:42.424677+00	
00000000-0000-0000-0000-000000000000	2d8f4c43-8afa-46c9-a291-7f4254f66d09	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 14:40:42.425257+00	
00000000-0000-0000-0000-000000000000	0ea5dd19-26a4-4a0f-ae0b-0f6389fa085a	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 14:40:42.453338+00	
00000000-0000-0000-0000-000000000000	ee1c76cc-5afa-48bb-8603-875e2e9fa8ec	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 16:22:22.939976+00	
00000000-0000-0000-0000-000000000000	48bb1854-95af-4daa-9e85-f0f8d8445bb6	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 16:22:22.940586+00	
00000000-0000-0000-0000-000000000000	4f20474c-91b1-4d7c-a7a9-5bfd7d85819f	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 16:22:22.950319+00	
00000000-0000-0000-0000-000000000000	07051904-8f41-4dba-8a4c-08fc3e1fb53c	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 16:22:22.954753+00	
00000000-0000-0000-0000-000000000000	ecb90dac-c6a2-439e-a620-af4708e46abb	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 16:22:22.968001+00	
00000000-0000-0000-0000-000000000000	acdf8b2b-fc0f-4409-b385-f73829892dcc	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 16:22:22.968569+00	
00000000-0000-0000-0000-000000000000	fe31630b-b933-4d10-badb-150d8a271323	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 16:22:22.974928+00	
00000000-0000-0000-0000-000000000000	33c6bdf9-fe1a-4191-a23f-d98925620238	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 16:22:22.980053+00	
00000000-0000-0000-0000-000000000000	0bc90f76-f735-4638-810f-90b9b13ad39f	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-15 16:22:22.985005+00	
00000000-0000-0000-0000-000000000000	b6dad1dc-adac-4f8f-880a-ba5a17f8c41b	{"action":"user_recovery_requested","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"user"}	2023-04-15 16:46:56.373873+00	
00000000-0000-0000-0000-000000000000	ae1476fd-5d92-42a8-87f8-320c2fb4cb15	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-15 16:48:20.636348+00	
00000000-0000-0000-0000-000000000000	4ae9a9e5-645c-4d02-b327-f0a1de686fe4	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-15 17:30:29.339892+00	
00000000-0000-0000-0000-000000000000	8800bc02-c0e7-451b-bc69-0ac9261a2db4	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-15 17:43:55.755321+00	
00000000-0000-0000-0000-000000000000	8b6a2dae-b40b-48a5-8829-b9068ad9d10a	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-16 08:00:49.154176+00	
00000000-0000-0000-0000-000000000000	459922e6-09c9-43a2-b1a7-22aa0224a6f8	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-16 11:06:30.327296+00	
00000000-0000-0000-0000-000000000000	175c545c-7fdc-4129-851f-c2367f1f55ac	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 06:24:59.734561+00	
00000000-0000-0000-0000-000000000000	0af280a9-c905-43a4-8b6d-1bafad2523cb	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 06:24:59.73519+00	
00000000-0000-0000-0000-000000000000	994104e9-d710-44de-b575-39508555c015	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 06:25:07.922464+00	
00000000-0000-0000-0000-000000000000	38167b91-3f8c-4952-9393-4d164a64bc72	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 06:25:07.923106+00	
00000000-0000-0000-0000-000000000000	aad3942a-836b-42e3-babb-7a238d7c183b	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 06:29:59.281811+00	
00000000-0000-0000-0000-000000000000	61c6e982-c4d1-4f88-8bc5-25a663bf766c	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 06:29:59.282411+00	
00000000-0000-0000-0000-000000000000	6c8e4d73-763a-4170-83f2-fff8e964deb2	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 06:29:59.301932+00	
00000000-0000-0000-0000-000000000000	dcabd20d-b329-46c6-9c91-709802ce0331	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-17 06:29:59.415343+00	
00000000-0000-0000-0000-000000000000	542c47f6-6a3a-40bc-8190-f2859a024ddc	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 07:29:32.85092+00	
00000000-0000-0000-0000-000000000000	e656d7ca-c059-4407-a131-acda2d92c2ce	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 07:29:32.851509+00	
00000000-0000-0000-0000-000000000000	55f040df-9633-49a0-a813-2d9a16aad57f	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 08:40:26.941713+00	
00000000-0000-0000-0000-000000000000	da5f760b-6348-4f19-bffd-4c1751c7d973	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 08:40:26.942221+00	
00000000-0000-0000-0000-000000000000	7371d170-f290-4944-a654-48a535b4a6de	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 09:39:56.157526+00	
00000000-0000-0000-0000-000000000000	a1354b8e-b38e-40be-9949-952cb4ed197a	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 09:39:56.158115+00	
00000000-0000-0000-0000-000000000000	d5872f4f-c4ad-40ef-b9db-2fc78b5a9388	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 09:39:56.279084+00	
00000000-0000-0000-0000-000000000000	f31c1b7c-ce46-416f-8fc1-f7eb2b21d9c5	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 10:40:14.230926+00	
00000000-0000-0000-0000-000000000000	393c8bf1-46c5-45a8-9d3b-e6d30043ebe4	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 10:40:14.231534+00	
00000000-0000-0000-0000-000000000000	54e85998-468d-45a8-84bd-9dd8e0406c1c	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 10:40:14.312009+00	
00000000-0000-0000-0000-000000000000	bb14b190-7cc3-4a61-8843-f6f861669138	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 11:07:18.602918+00	
00000000-0000-0000-0000-000000000000	8bfb8c8f-4f92-43dc-ab3f-0d2a58a0e181	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 11:07:18.603522+00	
00000000-0000-0000-0000-000000000000	53ece531-aacd-4f24-bbb0-af9b6d25afa7	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-17 11:07:18.83816+00	
00000000-0000-0000-0000-000000000000	2e41dd8b-1a77-44dc-9d54-6b4ed9922ccf	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-18 15:53:26.382269+00	
00000000-0000-0000-0000-000000000000	df8453bd-b850-4cc0-9199-d5bab9148993	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-18 15:53:26.383559+00	
00000000-0000-0000-0000-000000000000	00f60d15-aa05-4ff8-b1d9-d8eaa6c04a83	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-18 15:55:23.977629+00	
00000000-0000-0000-0000-000000000000	3c2d91dc-f6fb-456a-9792-c7c57b4bd190	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-18 15:55:23.978153+00	
00000000-0000-0000-0000-000000000000	93687ac8-6a01-4f51-a820-50af03b2ed76	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-18 15:55:24.040652+00	
00000000-0000-0000-0000-000000000000	17aa7e59-3b07-4871-8ad8-fa29347c62b5	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 15:59:35.695903+00	
00000000-0000-0000-0000-000000000000	ad5bef68-9cfc-4d50-8123-ddb016a6a9ed	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 15:59:40.094897+00	
00000000-0000-0000-0000-000000000000	5e928478-052d-4c7d-bb85-943e844a66ba	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 07:29:32.857785+00	
00000000-0000-0000-0000-000000000000	87425c89-d270-44d8-b089-66212fb381dd	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 07:29:32.858446+00	
00000000-0000-0000-0000-000000000000	ead00fba-3344-432b-ae7f-74819882e5c4	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 08:40:26.937988+00	
00000000-0000-0000-0000-000000000000	869d9480-797f-4e48-8c20-7523346a5b46	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-17 08:40:26.938675+00	
00000000-0000-0000-0000-000000000000	2f1307fe-2170-4843-a8f2-865860cb2eb5	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:26:00.530734+00	
00000000-0000-0000-0000-000000000000	0764b30f-90f1-4877-9c53-bb6b14dbdb65	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:30:07.599727+00	
00000000-0000-0000-0000-000000000000	eb91b421-a386-4ba9-9481-0a1be03de153	{"action":"user_signedup","actor_id":"3b5f0383-631a-4c3a-b730-ec2507854b09","actor_name":"Gautam RK","actor_username":"citiesskylinegautam@gmail.com","actor_via_sso":false,"log_type":"team","traits":{"provider":"google"}}	2023-04-18 16:32:21.5147+00	
00000000-0000-0000-0000-000000000000	b758a400-c6a3-4834-b8bb-2fdfa6db9dcd	{"action":"login","actor_id":"3b5f0383-631a-4c3a-b730-ec2507854b09","actor_name":"Gautam RK","actor_username":"citiesskylinegautam@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2023-04-18 16:33:51.843724+00	
00000000-0000-0000-0000-000000000000	b91d76bb-f5db-4d31-bf9f-4883d285253e	{"action":"login","actor_id":"3b5f0383-631a-4c3a-b730-ec2507854b09","actor_name":"Gautam RK","actor_username":"citiesskylinegautam@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2023-04-18 16:33:57.712731+00	
00000000-0000-0000-0000-000000000000	0aeabced-17c4-44f0-a09c-36ae0f1311d9	{"action":"login","actor_id":"3b5f0383-631a-4c3a-b730-ec2507854b09","actor_name":"Gautam RK","actor_username":"citiesskylinegautam@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2023-04-18 16:34:22.964613+00	
00000000-0000-0000-0000-000000000000	bf30b6d7-2ff9-42ca-bc74-f52d45686a9c	{"action":"logout","actor_id":"3b5f0383-631a-4c3a-b730-ec2507854b09","actor_name":"Gautam RK","actor_username":"citiesskylinegautam@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:35:33.328537+00	
00000000-0000-0000-0000-000000000000	6885a076-883b-4dfb-9fa1-e95a8f2a673d	{"action":"login","actor_id":"3b5f0383-631a-4c3a-b730-ec2507854b09","actor_name":"Gautam RK","actor_username":"citiesskylinegautam@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2023-04-18 16:35:39.165754+00	
00000000-0000-0000-0000-000000000000	85e3dcc6-fa39-49b0-8b2a-850c5206eff7	{"action":"logout","actor_id":"3b5f0383-631a-4c3a-b730-ec2507854b09","actor_name":"Gautam RK","actor_username":"citiesskylinegautam@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:42:02.342309+00	
00000000-0000-0000-0000-000000000000	8dfa1632-750f-444e-b88e-3f25961784c6	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:42:29.18413+00	
00000000-0000-0000-0000-000000000000	66b855dd-e0c2-40cb-9c72-60c095a3a162	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:42:51.409618+00	
00000000-0000-0000-0000-000000000000	daa62f73-2b7e-47d7-97f1-f6fde78434f3	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:45:34.628656+00	
00000000-0000-0000-0000-000000000000	36a434cb-e6ea-4892-bb8a-a42072ec72f2	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:45:42.538875+00	
00000000-0000-0000-0000-000000000000	2f18ce15-4fb0-43a6-93b2-7b32e1050c0c	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:46:28.948143+00	
00000000-0000-0000-0000-000000000000	5badcb93-3a6c-43da-b711-d461c3f53a7d	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:51:21.520398+00	
00000000-0000-0000-0000-000000000000	b790da32-509f-4458-ac84-786cb5445078	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:52:11.521843+00	
00000000-0000-0000-0000-000000000000	fd1f3049-b064-49c2-adca-331597166695	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:52:13.532528+00	
00000000-0000-0000-0000-000000000000	4f337ee0-b217-40a3-8e3a-5ff7206b3e2e	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:52:15.505435+00	
00000000-0000-0000-0000-000000000000	c6504eda-1443-4bf8-a9b9-baa68deed50d	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:52:35.70922+00	
00000000-0000-0000-0000-000000000000	72d30df2-381a-44e9-b652-7323f184b04c	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:52:42.00841+00	
00000000-0000-0000-0000-000000000000	e3f7a2b8-09ff-4df2-9f5b-52523f35d305	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:52:48.939311+00	
00000000-0000-0000-0000-000000000000	5453589a-c3c9-4ecf-b73e-db253999cec7	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:55:03.765567+00	
00000000-0000-0000-0000-000000000000	20d4967c-bd5a-46fa-9a98-0ae5a4787ad9	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:55:05.903465+00	
00000000-0000-0000-0000-000000000000	708f8ae6-15c6-4274-8a86-4971b08b26b3	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:57:33.87832+00	
00000000-0000-0000-0000-000000000000	bed22474-a016-4ba9-b1f8-4c55791ab411	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:57:35.576622+00	
00000000-0000-0000-0000-000000000000	ed00a5d1-9df0-46e7-9e00-966820929b76	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:57:37.088291+00	
00000000-0000-0000-0000-000000000000	d45cce7a-05a7-4979-a720-7dc21816b404	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:57:46.113559+00	
00000000-0000-0000-0000-000000000000	9504be6e-86e5-473b-a396-fc420c9967bf	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:57:52.443974+00	
00000000-0000-0000-0000-000000000000	bf8826ef-9c1f-4505-b60f-c350f9089618	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:58:10.847098+00	
00000000-0000-0000-0000-000000000000	c334048a-bb3c-413d-b5ca-bead79fcf7c9	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:58:24.344652+00	
00000000-0000-0000-0000-000000000000	491b4ec2-15ea-4a8f-b64f-b5b9c6ae2127	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:58:26.658491+00	
00000000-0000-0000-0000-000000000000	d82b4d40-9904-4994-93d0-5dd8545ae212	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:58:41.320697+00	
00000000-0000-0000-0000-000000000000	efb983f8-26bc-47b4-88a9-0c3a197bd877	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:59:07.933331+00	
00000000-0000-0000-0000-000000000000	3170d3e8-2fef-4465-ad84-c3b19430bbf7	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 16:59:09.404707+00	
00000000-0000-0000-0000-000000000000	106804e1-e038-4aee-a362-53a1562cc807	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 16:59:12.503021+00	
00000000-0000-0000-0000-000000000000	835b5c28-2e55-49ff-853b-193066f39f9f	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 17:00:01.092421+00	
00000000-0000-0000-0000-000000000000	775d2929-e7e0-4a44-b34a-8a1b1f3b8426	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 17:00:18.641225+00	
00000000-0000-0000-0000-000000000000	b9b43a7e-33c5-410e-bf8f-e4d4efd121da	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 17:01:20.059771+00	
00000000-0000-0000-0000-000000000000	71aa4a65-5230-4323-b0dc-444a0917a423	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 17:01:27.655226+00	
00000000-0000-0000-0000-000000000000	68e8761d-201b-4175-93d5-1fdb27f1e613	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 17:02:13.576946+00	
00000000-0000-0000-0000-000000000000	b4120112-52c0-4130-a8c6-65e415cc0f07	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 17:02:30.766774+00	
00000000-0000-0000-0000-000000000000	8e93cc3e-8531-41ad-a0d8-94fc009d5e79	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 17:03:09.271516+00	
00000000-0000-0000-0000-000000000000	d5306fef-2782-4c00-99ee-6589ffacc575	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-18 17:03:14.223207+00	
00000000-0000-0000-0000-000000000000	2f0f1908-b190-45e3-8fda-09fd8ab2899b	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-18 17:03:35.944047+00	
00000000-0000-0000-0000-000000000000	38d0bdf1-f768-4095-b230-4b84fd9b2c9d	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-19 09:50:59.009175+00	
00000000-0000-0000-0000-000000000000	dccff2d8-d92c-48ad-91b5-3f248da8ac52	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-19 09:50:59.010492+00	
00000000-0000-0000-0000-000000000000	1ea84e37-3433-4f3e-beb2-c5108faabc54	{"action":"token_refreshed","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-19 09:50:59.011573+00	
00000000-0000-0000-0000-000000000000	3a89822d-8cfb-4a40-b36d-5c5a09d1b875	{"action":"token_revoked","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"token"}	2023-04-19 09:50:59.012783+00	
00000000-0000-0000-0000-000000000000	0dd03dd8-9bd6-44df-8ab9-4b8378cc3903	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-19 09:52:24.171448+00	
00000000-0000-0000-0000-000000000000	bc0f325f-893a-4cb6-a196-4fe8ac601dd8	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-19 09:52:29.950515+00	
00000000-0000-0000-0000-000000000000	cef62074-cce2-4236-aa42-e91ef86333eb	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-19 09:54:43.389899+00	
00000000-0000-0000-0000-000000000000	3874a50c-496f-4f2d-b24a-7134f2c89ed4	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-19 09:54:45.206767+00	
00000000-0000-0000-0000-000000000000	b24f5fed-3f93-46ca-897b-e9fed3f31d40	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-19 09:55:14.439456+00	
00000000-0000-0000-0000-000000000000	79650fe6-1a99-4320-bc3e-17a675fa6a2a	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-19 09:55:21.398182+00	
00000000-0000-0000-0000-000000000000	6bf42541-b04d-488e-9e46-660ae004ea73	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-19 09:55:28.515127+00	
00000000-0000-0000-0000-000000000000	75fe46a7-217f-47fa-a167-64792f81e526	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-19 09:55:51.651979+00	
00000000-0000-0000-0000-000000000000	314b15ef-393e-4ee3-8e3a-bf63e2df160e	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-19 09:56:17.530426+00	
00000000-0000-0000-0000-000000000000	26d08e76-5df3-48a5-9b99-1aac47e53c4f	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-19 09:56:43.536164+00	
00000000-0000-0000-0000-000000000000	c912b213-1f1d-4e11-9c41-6f7cabef0205	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-19 09:56:48.199209+00	
00000000-0000-0000-0000-000000000000	4c001eb7-9fad-4e26-b27d-60b3ea347832	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-19 09:57:44.407949+00	
00000000-0000-0000-0000-000000000000	a1f58945-0fab-4110-a1bb-3af924d5d7d1	{"action":"logout","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account"}	2023-04-19 10:22:31.941201+00	
00000000-0000-0000-0000-000000000000	59ce11a2-dc65-4f23-9268-992f79527271	{"action":"login","actor_id":"474a5778-954a-4a66-adbd-d9ba877b3016","actor_username":"itswhocaresman@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2023-04-19 10:22:33.313182+00	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at) FROM stdin;
474a5778-954a-4a66-adbd-d9ba877b3016	474a5778-954a-4a66-adbd-d9ba877b3016	{"sub": "474a5778-954a-4a66-adbd-d9ba877b3016", "email": "itswhocaresman@gmail.com"}	email	2023-03-23 05:50:31.820414+00	2023-03-23 05:50:31.820494+00	2023-03-23 05:50:31.820494+00
104327590259205138548	3b5f0383-631a-4c3a-b730-ec2507854b09	{"iss": "https://www.googleapis.com/userinfo/v2/me", "sub": "104327590259205138548", "name": "Gautam RK", "email": "citiesskylinegautam@gmail.com", "picture": "https://lh3.googleusercontent.com/a/AGNmyxaIrWNxBdGTvjgvFLDSysTjvGVVMCpYvOwxoHOv=s96-c", "full_name": "Gautam RK", "avatar_url": "https://lh3.googleusercontent.com/a/AGNmyxaIrWNxBdGTvjgvFLDSysTjvGVVMCpYvOwxoHOv=s96-c", "provider_id": "104327590259205138548", "email_verified": true}	google	2023-04-18 16:32:21.51252+00	2023-04-18 16:32:21.51256+00	2023-04-18 16:35:39.16415+00
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
c43d3673-9345-4242-b54b-746797cf6a3f	2023-04-19 10:22:33.317308+00	2023-04-19 10:22:33.317308+00	password	b14c8b6a-9996-4c30-be0f-eba7d43b1206
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	93	9QD38aruU9qVcj4Cca7czA	474a5778-954a-4a66-adbd-d9ba877b3016	f	2023-04-19 10:22:33.315082+00	2023-04-19 10:22:33.315082+00	\N	c43d3673-9345-4242-b54b-746797cf6a3f
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, from_ip_address, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after) FROM stdin;
c43d3673-9345-4242-b54b-746797cf6a3f	474a5778-954a-4a66-adbd-d9ba877b3016	2023-04-19 10:22:33.31379+00	2023-04-19 10:22:33.31379+00	\N	aal1	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at) FROM stdin;
00000000-0000-0000-0000-000000000000	3b5f0383-631a-4c3a-b730-ec2507854b09	authenticated	authenticated	citiesskylinegautam@gmail.com		2023-04-18 16:32:21.515375+00	\N		\N		\N			\N	2023-04-18 16:35:39.166204+00	{"provider": "google", "providers": ["google"]}	{"iss": "https://www.googleapis.com/userinfo/v2/me", "sub": "104327590259205138548", "name": "Gautam RK", "email": "citiesskylinegautam@gmail.com", "picture": "https://lh3.googleusercontent.com/a/AGNmyxaIrWNxBdGTvjgvFLDSysTjvGVVMCpYvOwxoHOv=s96-c", "full_name": "Gautam RK", "avatar_url": "https://lh3.googleusercontent.com/a/AGNmyxaIrWNxBdGTvjgvFLDSysTjvGVVMCpYvOwxoHOv=s96-c", "provider_id": "104327590259205138548", "email_verified": true}	\N	2023-04-18 16:32:21.507555+00	2023-04-18 16:35:39.1701+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	474a5778-954a-4a66-adbd-d9ba877b3016	authenticated	authenticated	itswhocaresman@gmail.com	$2a$10$DXAPdzG/N3X2ljr71CU/N.lWsOPwRTPPKSJpZ4/1dSb95AxhHK87W	2023-03-23 05:50:47.620725+00	\N		2023-03-23 05:50:31.823677+00	bcfaddeada0c0cfd3ec2084511d459c3306a953cf7dceff3a33125c0	2023-04-15 16:46:56.376797+00			\N	2023-04-19 10:22:33.313742+00	{"provider": "email", "providers": ["email"]}	{}	\N	2023-03-23 05:50:31.805774+00	2023-04-19 10:22:33.316448+00	\N	\N			\N		0	\N		\N	f	\N
\.


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: next_auth; Owner: postgres
--

COPY next_auth.accounts (id, type, provider, "providerAccountId", refresh_token, access_token, expires_at, token_type, scope, id_token, session_state, oauth_token_secret, oauth_token, "userId") FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: next_auth; Owner: postgres
--

COPY next_auth.sessions (id, expires, "sessionToken", "userId") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: next_auth; Owner: postgres
--

COPY next_auth.users (id, name, email, "emailVerified", image) FROM stdin;
\.


--
-- Data for Name: verification_tokens; Type: TABLE DATA; Schema: next_auth; Owner: postgres
--

COPY next_auth.verification_tokens (identifier, token, expires) FROM stdin;
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
\.


--
-- Data for Name: Coins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Coins" ("Symbol", "CoinName", "Algorithm", "IsTrading", "ProofType", "TotalCoinsMined", "TotalCoinSupply") FROM stdin;
42	42 Coin	Scrypt	t	PoW/PoS	41.99995383	42
365	365Coin	X11	t	PoW/PoS	\N	2300000000
404	404Coin	Scrypt	t	PoW/PoS	1055184902	532000000
611	SixEleven	SHA-256	t	PoW	\N	611000
808	808	SHA-256	t	PoW/PoS	0	0
1337	EliteCoin	X13	t	PoW/PoS	29279424623	314159000000
2015	2015 coin	X11	t	PoW/PoS	\N	0
BTC	Bitcoin	SHA-256	t	PoW	17927175	21000000
ETH	Ethereum	Ethash	t	PoW	107684222.7	0
LTC	Litecoin	Scrypt	t	PoW	63039243.3	84000000
DASH	Dash	X11	t	PoW/PoS	9031294.376	22000000
XMR	Monero	CryptoNight-V7	t	PoW	17201143.14	0
ETC	Ethereum Classic	Ethash	t	PoW	113359703	210000000
ZEC	ZCash	Equihash	t	PoW	7383056.25	21000000
BTS	Bitshares	SHA-512	t	PoS	2741570000	3600570502
DGB	DigiByte	Multiple	t	PoW	11406219141	21000000000
BTCD	BitcoinDark	SHA-256	t	PoW/PoS	1288862	22000000
CRAIG	CraigsCoin	X11	t	PoS	\N	30000000
XBS	Bitstake	X11	t	PoW/PoS	0	1300000
XPY	PayCoin	SHA-256	t	PoS	11995334.88	12500000
PRC	ProsperCoin	Scrypt	t	PoW	5768310	21000000
YBC	YbCoin	Multiple	t	PoS	\N	200000000
DANK	DarkKush	X13	t	PoW/PoS	\N	3000000
GIVE	GiveCoin	X11	t	PoW	\N	500000000
KOBO	KoboCoin	X15	t	PoW/PoS	25542535.59	350000000
DT	DarkToken	NIST5	t	PoW/PoS	\N	0
CETI	CETUS Coin	Scrypt	t	PoW/PoS	\N	0
SPR	Spreadcoin	X11	t	PoW	11149734	20000000
WOLF	Insanity Coin	X11	t	PoW	\N	50000000
ACOIN	ACoin	SHA-256	t	PoW	0	1600000
AERO	Aero Coin	X13	t	PoS	0	7000000
ALF	AlphaCoin	Scrypt	t	PoW	\N	210182000
AGS	Aegis	X13	t	PoS	\N	0
AMC	AmericanCoin	Scrypt	t	PoW	\N	168000000
ALN	AlienCoin	Scrypt	t	PoW	\N	200000000
APEX	ApexCoin	X13	t	PoW/PoS	0	6000000
ARCH	ArchCoin	Scrypt	t	PoS	0	16403135
ARG	Argentum	Scrypt	t	PoW	12205795.44	64000000
ARI	AriCoin	Scrypt	t	PoW	\N	322649400
AUR	Aurora Coin	Scrypt	t	PoW/PoS	18135099.99	16768584
BET	BetaCoin	SHA-256	t	PoW	0	32000000
BEAN	BeanCash	SHA-256	t	PoW/PoS	\N	50000000000
BLU	BlueCoin	Scrypt	t	PoW/PoS	635423900	0
BQC	BQCoin	Scrypt	t	PoW	\N	88000000
XMY	MyriadCoin	Multiple	t	PoW	1688254250	2000000000
MOON	MoonCoin	Scrypt	t	PoW	88	384000000000
ZET	ZetaCoin	SHA-256	t	PoW	170204389.8	169795588
SXC	SexCoin	Scrypt	t	PoW	128940951.2	250000000
QTL	Quatloo	Scrypt	t	PoW	7357794.793	100000000
ENRG	EnergyCoin	Scrypt	t	PoW/PoS	123062801.1	0
QRK	QuarkCoin	Quark	t	PoW	259557164.9	247000000
RIC	Riecoin	Groestl	t	PoW	49548585.14	84000000
DGC	Digitalcoin 	Scrypt	t	PoW	33442988.34	48166000
LIMX	LimeCoinX	X11	t	PoW	0	21000000
BTB	BitBar	Scrypt	t	PoW/PoS	42579.4769	500000
CAIX	CAIx	Scrypt	t	PoS	\N	0
BTMK	BitMark	Scrypt	t	PoW	0	27580000
BUK	CryptoBuk	Scrypt	t	PoW/PoS	\N	100000000
CACH	Cachecoin	Scrypt	t	PoW	\N	2000000000
CAP	BottleCaps	Scrypt	t	PoW/PoS	\N	47433600
CASH	CashCoin	Scrypt	t	PoW/PoS	0	47433600
CAT	Catcoin	Scrypt	t	PoW	7219956.646	21000000
CBX	CryptoBullion	Scrypt	t	PoW/PoS	1039116.651	1000000
CCN	CannaCoin	Scrypt	t	PoW	4703879.518	13140000
CIN	CinderCoin	Multiple	t	PoW/PoS	0	114000000
CINNI	CINNICOIN	Scrypt	t	PoW	\N	15000000
CLR	CopperLark	SHA-256	t	PoW	\N	27200000
CMC	CosmosCoin	Scrypt	t	PoW/PoS	\N	100000000
CNC	ChinaCoin	Scrypt	t	PoW	\N	462500000
CNL	ConcealCoin	X11	t	PoW	\N	8500000
COMM	Community Coin	Scrypt	t	PoW/PoS	\N	1000000000
COOL	CoolCoin	Scrypt	t	PoS	0	100000000
CRACK	CrackCoin	X11	t	PoW	\N	6000000
CRYPT	CryptCoin	X11	t	PoW	4996986.206	18000000
CSC	CasinoCoin	Scrypt	t	PoC	39999997300	40000000000
DEM	eMark	SHA-256	t	PoW/PoS	0	0
DMD	Diamond	Groestl	t	PoW/PoS	3304487.747	4380000
XVG	Verge	Multiple	t	PoW	15929530669	16555000000
DRKC	DarkCash	X11	t	PoW/PoS	0	3720000
DSB	DarkShibe	Scrypt	t	PoW	0	2043962
DVC	DevCoin	SHA-256	t	PoW	18773857500	21000000000
EAC	EarthCoin	Scrypt	t	PoW	12539015187	13500000000
EFL	E-Gulden	Scrypt	t	PoW	20910478.81	21000000
ELC	Elacoin	Scrypt	t	PoW	0	75000000
EMC2	Einsteinium	Scrypt	t	PoW	218871896.5	299792458
EMD	Emerald	Scrypt	t	PoW	19496786.31	32000000
EXCL	Exclusive Coin	PoS	t	PoS	5679705	0
EXE	ExeCoin	Scrypt	t	PoW	\N	21000000
EZC	EZCoin	Scrypt	t	PoW	\N	84000000
FLAP	Flappy Coin	Scrypt	t	PoW	0	100000000000
FC2	Fuel2Coin	X11	t	PoS	0	100000000
FFC	FireflyCoin	SHA-256	t	PoW	\N	700000000000
FIBRE	FIBRE	NIST5	t	PoW/PoS	0	624000
FRC	FireRoosterCoin	SHA-256	t	PoW	0	2602410
FLT	FlutterCoin	Scrypt	t	PoS/PoW/PoT	461829905.3	0
FRK	Franko	Scrypt	t	PoW	1142732.149	11235813
FRAC	FractalCoin	X11	t	PoW	\N	1000000
FSTC	FastCoin	Scrypt	f	PoW	\N	165888000
FTC	FeatherCoin	NeoScrypt	t	PoW	208669093	336000000
GDC	GrandCoin	Scrypt	t	PoW	884125802	1420609614
GLC	GlobalCoin	Scrypt	t	PoW	65672720.47	70000000
GLD	GoldCoin	Scrypt	t	PoW	41658648	72245700
GLX	GalaxyCoin	Scrypt	t	PoW/PoS	\N	538214400
GLYPH	GlyphCoin	X11	t	PoW/PoS	0	7000000
GML	GameLeagueCoin	Scrypt	t	PoW/PoS	\N	500000000
GUE	GuerillaCoin	X11	t	PoW/PoS	\N	19500000
HAL	Halcyon	X15	t	PoW/PoS	0	0
HBN	HoboNickels	Scrypt	t	PoW/PoS	89266933.68	120000000
HUC	HunterCoin	Multiple	t	PoW	0	42000000
HVC	HeavyCoin	Multiple	t	PoW	\N	128000000
HYP	HyperStake	X11	t	PoS	1678520091	0
ICB	IceBergCoin	NIST5	t	PoW/PoS	\N	8750000
IFC	Infinite Coin	Scrypt	t	PoW	90595753019	90600000000
IOC	IOCoin	X11	t	PoW/PoS	17650913.97	22000000
IXC	IXcoin	SHA-256	t	PoW	21089349	21000000
JBS	JumBucks Coin	X11	t	PoW/PoS	0	3293010
JKC	JunkCoin	Scrypt	t	PoW	\N	107000000
JUDGE	JudgeCoin	X13	t	PoW/PoS	0	21600000
KDC	Klondike Coin	Scrypt	t	PoW	\N	20000000
KEYC	KeyCoin	X13	f	PoW/PoS	\N	1000000
KGC	KrugerCoin	Scrypt	t	PoW	151447649.8	265420800
LK7	Lucky7Coin	Scrypt	t	PoW/PoS	\N	99792000
LKY	LuckyCoin	Scrypt	t	PoW	19326319.14	20000000
LSD	LightSpeedCoin	NIST5	t	PoW/PoS	\N	900000
LTB	Litebar 	Scrypt	t	PoW	1104344.229	1350000
LTCD	LitecoinDark	Scrypt	t	PoW	0	82003200
LTCX	LitecoinX	X11	t	PoW	\N	84000000
LXC	LibrexCoin	X11	t	PoW/PoS	0	1000000
LYC	LycanCoin	Scrypt	t	PoW	\N	4950000000
MAX	MaxCoin	SHA3	t	PoW/PoS	61445805	100000000
MEC	MegaCoin	Scrypt	t	PoW	38151999.99	42000000
MED	MediterraneanCoin	HybridScryptHash256	t	PoW	40431856.9	200000000
MINRL	Minerals Coin	X11	f	PoW/PoS	\N	1000000
MINT	MintCoin	Scrypt	t	PoS	21293925445	0
MN	Cryptsy Mining Contract	SHA-256	t	PoW	\N	0
MINC	MinCoin	Scrypt	t	PoW	5804204.888	10000000
MRY	MurrayCoin	Scrypt	t	PoW	\N	58000000
MZC	MazaCoin	SHA-256	t	PoW/PoS	1613836100	2419200000
NAN	NanoToken	Scrypt	t	PoW	\N	80000000
NAUT	Nautilus Coin	Scrypt	t	PoS	16180000	16180000
NAV	NavCoin	X13	t	PoW/PoS	66087096.21	0
NBL	Nybble	Scrypt	t	PoW	\N	210000000
NMB	Nimbus Coin	X15	t	PoW/PoS	\N	25000000
NRB	NoirBits	SHA-256	t	PoW	0	50000000
NOBL	NobleCoin	Scrypt	t	PoW	2366066306	15000000000
NRS	NoirShares	Scrypt	t	PoW/PoS	\N	5000000
NMC	Namecoin	SHA-256	t	PoW	14736400	21000000
NYAN	NyanCoin	Scrypt	t	PoW	334709223.5	337000000
OPAL	OpalCoin	X13	t	PoW/PoS	15156364.33	0
ORB	Orbitcoin	NeoScrypt	t	PoW/PoS	3220616.279	3770000
PHS	PhilosophersStone	Scrypt	t	PoW	\N	8891840
POT	PotCoin	Scrypt	t	PoW/PoS	222677226	420000000
PSEUD	PseudoCash	X13	t	PoW/PoS	\N	2200000
PXC	PhoenixCoin	Scrypt	t	PoW/PoS	73959274.63	98000000
PYC	PayCoin	Scrypt	t	PoW/PoS	\N	30000000
RDD	Reddcoin	Scrypt	t	PoW/PoS	29315567169	0
RIPO	RipOffCoin	Scrypt	t	PoW	0	12000000
RPC	RonPaulCoin	Scrypt	t	PoW	1104157.422	21000000
RT2	RotoCoin	Scrypt-n	t	PoW/PoS	\N	288000
RYC	RoyalCoin	Scrypt	t	PoW	\N	140000000
RZR	RazorCoin	Scrypt	t	PoW	\N	4000000
SAT2	Saturn2Coin	Scrypt	t	PoW	\N	15000000000
SBC	StableCoin	Scrypt	t	PoW	24215181.73	250000000
SFR	SaffronCoin	Multiple	t	PoW	\N	111000000
SHADE	ShadeCoin	Scrypt	t	PoW/PoS	\N	2000000
SHLD	ShieldCoin	X15	t	PoW/PoS	0	1000000
SILK	SilkCoin	Scrypt	t	PoW/PoS	0	1000000
SLG	SterlingCoin	X13	t	PoS	\N	0
SMC	SmartCoin	Scrypt	t	PoW	25593737.14	51200000
SOLE	SoleCoin	X15	t	PoW/PoS	\N	1200000
SPA	SpainCoin	Scrypt-n	t	PoW	0	50000000
SPOTS	Spots	Scrypt	t	PoW	\N	100000000
SRC	SecureCoin	Scrypt	t	PoW	0	21000000
SSV	SSVCoin	X13	t	PoW	\N	21000000
SUPER	SuperCoin	X11	t	PoS	50707661.75	0
SYNC	SyncCoin	X11	t	PoW/PoS	1177	1000
SYS	SysCoin	SHA-256	t	PoW	563336541.3	888000000
TAG	TagCoin	Scrypt	t	PoW/PoS	\N	1000000
TAK	TakCoin	SHA-256	t	PoW/PoS	\N	7515187520
TES	TeslaCoin	Multiple	t	PoS	80260463.73	100000000
TGC	TigerCoin	SHA-256	t	PoW	43536800	47011968
TIT	TittieCoin	PHI1612	t	PoS	1622326490	2300000000
TOR	TorCoin	X11	t	PoW/PoS	1431851	10000000
TRC	TerraCoin	SHA-256	t	PoW	22935396	42000000
TITC	TitCoin	Scrypt	t	PoW	\N	1000000
ULTC	Umbrella	SHA-256	t	PoW	0	2625000
UNB	UnbreakableCoin	SHA-256	t	PoW	2278150	80000000
UNO	Unobtanium	SHA-256	t	PoW	200911.7915	250000
URO	UroCoin	X11	t	PoW	1207310	0
USDE	UnitaryStatus Dollar	Scrypt	t	PoW/PoS	1098952593	1600000000
UTC	UltraCoin	Scrypt	t	PoW/PoS	50235211.14	100000000
UTIL	Utility Coin	X13	t	PoW/PoS	0	0
VDO	VidioCoin	X11	t	PoW/PoS	\N	0
VIA	ViaCoin	Scrypt	t	PoW	23150892.17	23000000
VOOT	VootCoin	X11	t	PoW	0	0
VRC	VeriCoin	Scrypt	t	PoST	32021108.41	0
VTC	Vertcoin	Lyra2REv2	t	PoW	51173723.82	84000000
WDC	WorldCoin	Scrypt	t	PoW	119606941	265420800
XAI	SapienceCoin	X11	t	PoB/PoS	\N	0
XBOT	SocialXbotCoin	Scrypt	t	PoW/PoS	0	2000000
XC	X11 Coin	X11	t	PoW/PoS	6950831.097	5500000
XCSH	Xcash	Scrypt	f	PoW/PoS	\N	2400000
XCR	Crypti	Multiple	t	PoS	100000000	0
XJO	JouleCoin	SHA-256	t	PoW	39195739.36	45000000
XLB	LibertyCoin	X11	t	PoW/PoS	\N	16500000
XST	StealthCoin	X13	t	PoW/PoS	33093725.41	0
XXX	XXXCoin	Scrypt	t	PoW/PoS	0	50000000
YAC	YAcCoin	Scrypt	t	PoW	\N	2000000000
ZCC	ZCC Coin	Scrypt	t	PoW/PoS	147990238	1000000000
ZED	ZedCoins	Scrypt	t	PoW	\N	120000000
BCN	ByteCoin	CryptoNight	t	PoW	184067000000	184467000000
EKN	Elektron	X13	t	PoW/PoS	\N	3000000
XDN	DigitalNote 	CryptoNight	t	PoW	6906587610	10000000000
XAU	XauCoin	SHA-256	t	PoW	\N	2100000
BURST	BurstCoin	Shabal256	t	PoC	1813033920	2158812800
SJCX	StorjCoin	Counterparty	t	PoS	51173144	500000000
HUGE	BigCoin	Blake	t	PoW	\N	164429865
7	007 coin	Scrypt	t	PoW	\N	989800
MONA	MonaCoin	Scrypt	t	PoW	68194674.87	105120000
TEK	TekCoin	SHA-256	t	PoW/PoS	\N	100000000
NTRN	Neutron	SHA-256	t	PoW/PoS	39121694	68000000
SLING	Sling Coin	SHA-256	t	PoW	0	1000000
XSI	Stability Shares	Scrypt	t	PoW/PoS	\N	15000000
KTK	KryptCoin	Scrypt	t	PoS	0	17000000
FAIR	FairCoin	Groestl	t	PoW/PoS	53193831	0
NLG	Gulden	Scrypt	t	PoW	415032420	1680000000
RBY	RubyCoin	Scrypt	t	PoS	27184490.39	0
PTC	PesetaCoin	Scrypt	t	PoW	137517654.4	166386000
KORE	Kore	X13	t	PoW/PoS	2022464.887	12000000
WBB	Wild Beast Coin	Scrypt	t	PoW	181919.2436	2628000
SSD	Sonic Screw Driver Coin	SHA-256	t	PoW/PoS	\N	0
NOTE	Dnotes	Scrypt	t	PoS	174646113.9	500000000
FLO	Flo	Scrypt	t	PoW	152270664.9	160000000
MMXIV	MaieutiCoin	SHA-256	t	PoS	0	2014
8BIT	8BIT Coin	Scrypt	t	PoW/PoS	1467841	0
STV	Sativa Coin	X13	t	PoW/PoS	7096834	10000000
AM	AeroMe	X13	t	PoW/PoS	0	12000000
NKT	NakomotoDark	X11	t	PoW/PoS	\N	0
GHC	GhostCoin	Scrypt	t	PoW/PoS	\N	750000000
ABY	ArtByte	Scrypt	t	PoW	792537250	1000000000
MTR	MasterTraderCoin	X11	t	PoW/PoS	0	10110000
BCR	BitCredit	Momentum	t	PoW	0	210000000
XPB	Pebble Coin	CryptoNight	t	PoW	\N	0
XDQ	Dirac Coin	Blake	t	PoW	\N	2272800
FLDC	Folding Coin	Stanford Folding	t	PoW	719416990	1000000000
SMAC	Social Media Coin	X11	t	PoW/PoS	\N	0
U	Ucoin	X11	t	PoS	2689812	20000000
UIS	Unitus	Multiple	t	PoW	65113302	0
CYP	CypherPunkCoin	QuBit	t	PoW	6365285	0
QBK	QuBuck Coin	X13	t	PoS/PoB	\N	0
MARYJ	MaryJane Coin	X15	t	PoW/PoS	0	0
OMC	OmniCron	Scrypt	t	PoW	10140044.44	3371337
GIG	GigCoin	X11	t	PoW	\N	0
CC	CyberCoin	Scrypt	t	PoW/PoS	0	0
VTR	Vtorrent	Scrypt	t	PoW/PoS	11604722	20000000
METAL	MetalCoin	Scrypt	t	PoW	\N	0
GRE	GreenCoin	Scrypt	t	PoW	4610340641	10000000000
XG	XG Sports	XG Hash	t	PoW/PoS	\N	0
CHILD	ChildCoin	X11	t	PoW	\N	2000000
MINE	Instamine Nuggets	Scrypt	t	PoW	\N	21649485
ROS	ROS Coin	X11	t	PoW/PoS	\N	0
UNAT	Unattanium	SHA-256	t	PoW	0	0
GAIA	GAIA Platform	X11	t	PoS	\N	24000000
XCN	Cryptonite	M7 POW	t	PoW	708506520	1840000000
GMC	Gridmaster	Scrypt	t	PoW	0	84000000
MMC	MemoryCoin	Multiple	t	PoW	\N	10000000
CYC	ConSpiracy Coin 	X11	t	PoW	0	33000000
MSC	MasterCoin	Scrypt	t	PoW	619478	619478
EGG	EggCoin	Scrypt	t	PoW/PoS	\N	3891
CAMC	Camcoin	X11	f	PoW/PoS	\N	10000000
RBR	Ribbit Rewards	Multiple	t	PoW	\N	1000000000
ICASH	ICASH	X11	t	PoW	\N	1000000
NODE	Node	Curve25519	t	PoA	\N	1000000000
SOON	SoonCoin	SHA-256	t	PoW	12462620	21000000
BTMI	BitMiles	Scrypt	t	PoW	\N	4832660000
EVENT	Event Token	Scrypt	t	PoW/PoS	\N	0
1CR	1Credit	Scrypt	t	PoW	88213	92000000000
VIOR	ViorCoin	Scrypt	t	PoW/PoS	0	0
VMC	VirtualMining Coin	Scrypt-n	t	PoW	\N	1000000
MARSC	MarsCoin	X11	f	PoW	\N	33000000
EQM	Equilibrium Coin	SHA-256	t	PoW/PoS	\N	0
ISL	IslaCoin	X11	t	PoW/PoS	1513704	0
QSLV	Quicksilver coin	X11	t	PoW	0	33000000
XNA	DeOxyRibose	X11	t	PoS	\N	0
SKB	SkullBuzz	SHA-256	t	PoS	\N	0
FCS	CryptoFocus	X11	t	PoW/PoS	\N	0
NXS	Nexus	SHA3	t	PoW/nPoS	63657220	78000000
EAGS	EagsCoin	X11	t	PoW/PoS	\N	20445500
MWC	MultiWallet Coin	X11	t	PoW/PoS	\N	0
MARS	MarsCoin 	X11	t	PoW	32221574.82	33000000
XMS	Megastake	X11	t	PoW/PoS	\N	0
SIGU	Singular	Scrypt	t	PoW/PoS	0	0
M1	SupplyShock	X13	t	PoW/PoS	\N	0
DB	DarkBit	Scrypt	t	PoW/PoS	\N	0
CTO	Crypto	Lyra2RE	t	PoW	13742738	65789100
BITL	BitLux	X11	f	PoW/PoS	\N	0
FUTC	FutCoin	X13	t	PoW/PoS	\N	0
TAM	TamaGucci	Scrypt	t	PoW/PoS/PoC	\N	5300000
MRP	MorpheusCoin	X11	t	PoW	\N	3400000
XFC	Forever Coin	X11	t	PoS	\N	210000000
NANAS	BananaBits	Scrypt	t	PoW/PoS	\N	0
ACP	Anarchists Prime	SHA-256	t	PoW	14747200	53760000
DRZ	Droidz	QUAIT	t	PoW/PoS	8568038.359	5060000
BSC	BowsCoin	X11	t	PoW	15863837.5	21000000
DRKT	DarkTron	SHA-256	t	PoW/PoS	\N	1500000
CIRC	CryptoCircuits	vDPOS	t	PoS	0	0
EPY	Empyrean	Scrypt	t	PoW	\N	100000
SQL	Squall Coin	X11	t	PoS/PoW	329200.0164	0
CHA	Charity Coin	Scrypt	t	PoW	\N	500000
MIL	Milllionaire Coin	X11	t	PoW/PoS	0	0
QTZ	Quartz	SHA-256	t	PoW/PoS	\N	0
SPC	SpinCoin	NIST5	t	PoW/PoS	\N	0
DUB	DubCoin	X15	t	PoW/PoS	\N	0
GRAV	Graviton	SHA-256	t	PoW/PoS	\N	0
HEDGE	Hedgecoin	X13	t	PoW	\N	33000000
SONG	Song Coin	Scrypt	t	PoW	32565300	210240000
XSEED	BitSeeds	SHA-256	t	PoW/PoS	\N	0
CHIP	Chip	X11	t	PoW	\N	0
SPEC	SpecCoin	Scrypt	t	PoW	\N	3000000000
SPRTS	Sprouts	SHA-256	t	PoW/PoS	\N	0
ZNY	BitZeny	Scrypt	t	PoW	75614500	250000000
DIGS	Diggits	Scrypt	t	PoS	100000000	100000000
EXP	Expanse	Ethash	t	PoW	10495278	16906397
MAPC	MapCoin	X11	t	PoS	0	2228921.184
CON	Paycon	X13	t	PoW/PoS	23042604	50000000
SC	Siacoin	Blake2b	t	PoW	33098296530	0
LYB	LyraBar	Lyra2RE	t	PoW/PoS	\N	0
EMC	Emercoin	SHA-256	t	PoW/PoS	43059794.8	1000000000
BLITZ	BlitzCoin	X13	t	PoS	0	3852156
BHIRE	BitHIRE	Scrypt	f	PoS	\N	42000000
EGC	EverGreenCoin	X15	t	PoW/PoS	13530556.42	26298000
MND	MindCoin	X11	t	PoW	15867695	16000000
I0C	I0coin	SHA-256	t	PoW	20997476.87	21000000
DCR	Decred	BLAKE256	t	PoW/PoS	10365046.93	21000000
DOGED	DogeCoinDark	Scrypt	t	PoW	0	16500000000
RVR	Revolution VR	Scrypt	t	PoW	210000000	210000000
HODL	HOdlcoin	1GB AES Pattern Search	t	PoW	11448949	81962100
EDRC	EDRCoin	SHA-256	t	PoW/PoS	3669691.845	22000000
HTC	Hitcoin	X11	t	PoW/PoS	10996318099	26550000000
GAME	Gamecredits	Scrypt	t	PoW	69836100	84000000
DSH	Dashcoin	CryptoNight	t	PoW	0	18446744
DBIC	DubaiCoin	SHA-256	t	PoW/PoS	5129014	10500000
BIOS	BiosCrypto	Quark	t	PoW/PoS	0	20190463.55
DIEM	CarpeDiemCoin	SHA-256	t	PoW	21739971929	21626280000
RCX	RedCrowCoin	Scrypt	t	PoW/PoS	\N	3966666667
PWR	PWR Coin	NIST5	t	PoW/PoS	10069449032	0
TRUMP	TrumpCoin	Blake	t	PoS	0	12000000
BLRY	BillaryCoin	Scrypt	t	PoW/PoS	8998743.241	42000000
ETHS	EthereumScrypt	Scrypt	t	PoW/PoS	0	4200000
PXL	Phalanx	SHA-256	t	PoW	0	15000000
SOUL	SoulCoin	Scrypt	t	PoW/PoS	\N	1400000000
SSTC	SunShotCoin	X11	t	PoW	0	2250000000
GPU	GPU Coin	Scrypt	t	PoS	40477042	221052632
TAGR	Think And Get Rich Coin	X15	t	PoW/PoS	\N	30700000
HMP	HempCoin	Scrypt-n	t	PoW	0	5000000000
ADZ	Adzcoin	X11	t	PoW	45110324	84000000
MYC	MayaCoin	Scrypt	t	PoW/PoS	\N	250000000
VTA	VirtaCoin	Scrypt	t	PoW	0	21000000000
SOIL	SoilCoin	Dagger	t	PoW	5702048	30000000
YOC	YoCoin	Scrypt	t	PoW	636462.5598	168351300
UNIT	Universal Currency	SHA-256	t	PoW/PoS	0	210000000
AEON	AEON	CryptoNight-Lite	t	PoW	0	18400000
SIB	SibCoin	X11GOST	t	PoW	17263355	24000000
ERC	EuropeCoin	X11	t	PoW/PoS	10407269.79	384000000
AIB	AdvancedInternetBlock	Scrypt	t	PoW	\N	314159000000
XDB	DragonSphere	X11	t	PoW/PoS	\N	21007600
ANTI	Anti Bitcoin	SHA-256	t	PoW	0	42000000
COLX	ColossusCoinXT	X11	t	PoS	\N	21000000000
MNM	Mineum	X13	t	PoW/PoS	\N	10000000
ZEIT	ZeitCoin	Scrypt	t	PoS	36971236047	99000000000
CGA	Cryptographic Anomaly	Scrypt	t	PoW	\N	10000000000
SWING	SwingCoin	SHA-256	t	PoW/PoS	4377081.61	40000000
SAFEX	SafeExchangeCoin	Scrypt	t	PoC	2147483647	2147483647
NEBU	Nebuchadnezzar	PoS	t	PoS	20000000	20000000
AEC	AcesCoin	X11	t	PoS	\N	98000000
FRN	Francs	Scrypt	t	PoW	6570807.657	20000000
ADNT	Aiden	ScryptOG	f	PoW	84000000	84000000
N7	Number7	Scrypt	t	PoW	\N	270967742
CYG	Cygnus	X11	t	PoW/PoS	\N	25885320
LGBTQ	LGBTQoin	X11	t	PoW	\N	50000000
UTH	Uther	Dagger	t	PoW	\N	25885320
MPRO	MediumProject	PoS	t	PoW	\N	250000
KATZ	KATZcoin	SHA-256D	t	PoW/PoS	\N	100000000
SPM	Supreme	Scrypt	t	PoW/PoS	\N	88900000
FLX	Flash	Scrypt	t	PoW/PoS	\N	1000000
BOLI	BolivarCoin	X11	t	PoW	13654082.5	25000000
CLUD	CludCoin	Scrypt	t	PoW	\N	100200000
HVCO	High Voltage Coin	SHA-256	t	PoW/PoS	\N	1700000
GIZ	GIZMOcoin	X11	t	PoW/PoS	0	100000
FUZZ	Fuzzballs	Scrypt	t	PoW	\N	21000000
SCRT	SecretCoin	X11	t	PoW/PoS	0	21000000
XRA	Ratecoin	X11	t	PoW/PoS	134554941.2	75000000
XNX	XanaxCoin	Scrypt	t	PoW	\N	42000000
DBG	Digital Bullion Gold	PoS	t	PoS	0	15000000
WMC	WMCoin	X11	t	PoS	\N	1000000000
GOTX	GothicCoin	Scrypt	t	PoW	\N	313333333
SHREK	ShrekCoin	Scrypt	t	PoW/PoS	\N	1246000000
REV	Revenu	SHA-256	t	PoW/PoS	1195525	222725000
PBC	PabyosiCoin	X11	t	PoW/PoS	\N	31500000000
OBS	Obscurebay	X11	t	PoW/PoS	\N	6562000
EXIT	ExitCoin	Scrypt	t	PoW/PoS	\N	756000000
EDUC	EducoinV	Scrypt	t	PoW/PoS	\N	99000000
CLINT	Clinton	SHA-256	t	PoW	0	2421227
CKC	Clockcoin	SHA-256	t	PoW/PoS	16662820	525000000
VIP	VIP Tokens	NIST5	t	PoW/PoS	83450403	90000000
NXE	NXEcoin	NIST5	t	PoW/PoS	\N	2200000
ZOOM	ZoomCoin	Lyra2RE	t	PoW	\N	250000
YOVI	YobitVirtualCoin	SHA-256	t	PoS	\N	22830000
ORLY	OrlyCoin	X15	t	PoW/PoS	0	36000000
KUBOS	KubosCoin	Scrypt	f	PoW/PoS	\N	986899000000
SAK	SharkCoin	SHA-256	t	PoW	\N	400000000
EVIL	EvilCoin	X11	t	PoW/PoS	\N	21024000
COX	CobraCoin	Scrypt	t	PoW/PoS	\N	1012941176
BSD	BitSend	X11	t	PoW/PoS	24387724.5	139000000
DES	Destiny	Scrypt	t	PoW/PoS	\N	212625
BIT16	16BitCoin	NIST5	t	PoW/PoS	0	16000000
CMTC	CometCoin	Scrypt	t	PoW	\N	2000000
CHESS	ChessCoin	Scrypt	t	PoW/PoS	0	74666667
REE	ReeCoin	Scrypt	t	PoW/PoS	0	350000000
MARV	Marvelous	Scrypt	t	PoW	\N	400000000
OMNI	Omni	Scrypt	t	PoW	616448	616448
TRTK	TrollTokens	SHA-256	f	PoW/PoS	\N	860000000
LIR	Let it Ride	POS 3.0	t	PoS	38589808.67	33500000
SCRPT	ScryptCoin	Scrypt	t	PoW	\N	34181818
SPCIE	Specie	PoS	t	PoS	\N	9000000
CJ	CryptoJacks	X13	t	PoW/PoS	\N	500000000
PUT	PutinCoin	Scrypt	t	PoW/PoS	813092338.6	2000000000
KRAK	Kraken	SHA-256	t	PoW/PoS	\N	20 000 000
IBANK	iBankCoin	Scrypt	t	PoW/PoS	4526324	44333333
WRLGC	World Gold Coin	SHA-256	f	PoW	\N	51000000
BM	BitMoon	X13	t	PoS	\N	100000000
FRWC	Frankywillcoin	Scrypt	t	PoW/PoS	100000000	100000000
PSY	Psilocybin	SHA-256D	t	PoW/PoS	\N	4214600
RUST	RustCoin	Scrypt	t	PoW/PoS	\N	21212121
NZC	NewZealandCoin	Scrypt	t	PoW	\N	335800000
XPOKE	PokeChain	X13	t	PoS	\N	75000000
MUDRA	MudraCoin	X13	t	PoS	5000000	200000000
PIZZA	PizzaCoin	X11	t	PoW	1377917	25000000
LC	Lutetium Coin	X11	t	PoS	657000000	657000000
EXB	ExaByte (EXB)	SHA-256	t	PoW	\N	500000000
KMD	Komodo	Equihash	t	dPoW/PoW	115898131	200000000
GB	GoldBlocks	X11	t	PoW/PoS	15563873	50000000
EDC	EDC Blockchain	SHA-256	t	DPoS/LPoS	\N	5352058722
WAY	WayCoin	X11	t	PoS	0	100000000
TAB	MollyCoin	Scrypt	t	PoW/PoS	\N	25000000
STO	Save The Ocean	X11	t	PoW/PoS	\N	150000000
CTC	CarterCoin	Scrypt	t	PoW/PoS	43165500	90000000
TOT	TotCoin	Scrypt	t	PoW/PoS	\N	1613150000
MDC	MedicCoin	Scrypt	t	PoW/PoS	\N	33000000
FTP	FuturePoints	X11	t	PoS	\N	360000000
ZET2	Zeta2Coin	Quark	t	PoW/PoS	\N	1200000
CVNC	CovenCoin	SHA-256	t	PoW/PoS	\N	33000
KRB	Karbo	CryptoNight	t	PoW	7822432.724	10000000
TELL	Tellurion	X11	t	PoW/PoS	\N	3652422000
BXT	BitTokens	SHA-256	t	PoW/PoS	595429	21000000
ZYD	ZayedCoin	SHA-256	t	PoW	6243840	9736000
MST	MustangCoin	X11	t	PoW/PoS	657636.3455	3000000
GOON	Goonies	Scrypt	t	PoW	\N	270875968
ZNE	ZoneCoin	Scrypt	t	PoW/PoS	2581970	21000000
COVAL	Circuits of Value	Multiple	t	PoW	1000000000	1200000000
DGDC	DarkGold	X13	t	PoW/PoS	\N	1000000
TODAY	TodayCoin	Scrypt	t	PoW	\N	39200000
ROOT	RootCoin	Scrypt	t	PoW/PoS	1939889	0
DOPE	DopeCoin	Scrypt	t	PoW	116845228	200000000
FX	FCoin	Scrypt	t	PoW/PoS	\N	987600000
PIO	Pioneershares	X11	t	PoW/PoS	\N	200000
PROUD	PROUD Money	X11	t	PoW/PoS	0	10000000000
SMSR	Samsara Coin	QuBit	t	PoW/PoS	\N	60000000
UBIQ	Ubiqoin	Progressive-n	t	PoS	\N	500000000
ARM	Armory Coin	Scrypt	t	PoW/PoS	\N	1990000000
RING	RingCoin	Scrypt	t	PoW/PoS	\N	1900000000
LAZ	Lazarus	DPoS	t	DPoS	\N	10000000
BTCR	BitCurrency	Scrypt	t	PoS	169598616	0
FCTC	FaucetCoin	X13	f	PoS	\N	10000
MOOND	Dark Moon	Scrypt	t	PoW/PoS	\N	420000000
DLC	DollarCoin	SHA-256	t	PoW	9106714	10638298
SCN	Swiscoin	Scrypt	t	PoW/PoW	665200057	3100000000
BRONZ	BitBronze	Scrypt	t	PoW	\N	4502400
SH	Shilling	Scrypt	t	PoW	11119200	30000000
BUZZ	BuzzCoin	SHA-256D	t	PoW/PoS	19577787259	20000000000
MG	Mind Gene	SHA-256	t	PoW/PoS	\N	7500000000
PSI	PSIcoin	X11	t	PoS	\N	696969
XPO	Opair	PoS	t	PoS	74033806.79	74000000
PSB	PesoBit	Scrypt	t	PoW/PoS	33522957	0
FIT	Fitcoin	X11	t	PoW/PoS	\N	90000000
PINKX	PantherCoin	Scrypt	t	PoW/PoS	\N	735000000
UNF	Unfed Coin	Scrypt	t	PoW	\N	67000000
SPORT	SportsCoin	X11	t	PoS	\N	20000000
NTC	NineElevenTruthCoin	Scrypt	t	PoW/PoS	\N	130528084
EGO	EGOcoin	PoS	t	PoS	\N	60000000
GBRC	GBR Coin	Scrypt	t	PoW	0	87500000
HALLO	Halloween Coin	X11	t	PoW/PoS	264678458.3	1500000000
BBCC	BaseballCardCoin	Scrypt	t	PoW/PoS	\N	19000000
EMIGR	EmiratesGoldCoin	SHA-256	f	PoW	\N	4000000
BHC	BighanCoin	Quark	t	PoW	\N	411000000
CRAFT	Craftcoin	Scrypt	t	PoW/PoS	\N	49411760
OLYMP	OlympCoin	X11	t	PoW/PoS	\N	50000000
DPAY	DelightPay	X13	t	PoW/PoS	\N	90400000
ANTC	AntiLitecoin	Scrypt	f	PoW	\N	84000000
JOBS	JobsCoin	X11	t	PoW/PoS	\N	20000000000
DGORE	DogeGoreCoin	X11	t	PoW/PoS	\N	500000000
RMS	Resumeo Shares	NIST5	t	PoS	\N	9188302
FJC	FujiCoin	Scrypt-n	t	PoW	0	10000000
VAPOR	Vaporcoin	SHA-256	t	PoW/PoS	\N	2000000
XZC	ZCoin	Lyra2Z	t	PoW	7568281.25	21400000
PRE	Premium	Scrypt	t	PoW	\N	20000000
CALC	CaliphCoin	SHA-256	t	PoW	\N	135000000
LEA	LeaCoin	SHA-256	t	PoW	0	2000000000
CF	Californium	SHA-256	t	PoW	\N	2520000
CFC	CoffeeCoin	PoS	t	PoS	148716816	39999898
BS	BlackShadowCoin	X11	t	PoW/PoS	\N	2100000000
JIF	JiffyCoin	SHA-256D	t	PoW	\N	5108400
MONETA	Moneta	Scrypt	t	PoW	\N	184000000
RUBIT	Rublebit	Scrypt	t	PoW	\N	100000000
HCC	HappyCreatorCoin 	Scrypt	t	PoW	\N	100100000000
BRAIN	BrainCoin	X11	t	PoW/PoS	\N	22000000
ROYAL	RoyalCoin	X13	t	PoS	2500124	2500124
LFC	BigLifeCoin	X11	t	PoW	\N	9900000000
ZUR	Zurcoin	Quark	t	PoW	0	126000000
PEC	PeaceCoin	X11	t	PoW	\N	700000000
GMX	Goldmaxcoin	Scrypt	t	PoW	\N	84078950
32BIT	32Bitcoin	X11	t	PoW/PoS	\N	355000
GNJ	GanjaCoin V2	X14	t	PoW/PoS	100000000	100000000
TEAM	TeamUP	PoS	t	PoS	17818682.17	301000000
SCT	ScryptToken	Scrypt	t	PoW/PoS	\N	8842105
LANA	LanaCoin	SHA-256D	t	PoW/PoS	1082162636	7506000000
ELE	Elementrem	Ethash	t	PoW	26205539	26205539
GCC	GuccioneCoin	Scrypt	t	PoW	\N	39760000
EQUAL	EqualCoin	X13	t	PoW/PoS	\N	1000000000
2BACCO	2BACCO Coin	Scrypt	t	PoW/PoS	\N	81454545
DKC	DarkKnightCoin	Scrypt	t	PoW/PoS	\N	24000000
COC	Community Coin	SHA-256	t	PoW	\N	36129032
CHOOF	ChoofCoin	Scrypt	t	PoW/PoS	\N	40000000
CSH	CashOut	SHA-256	t	PoW	0	100000000
ZCL	ZClassic	Equihash	t	PoW	5613550	21000000
RYCN	RoyalCoin 2.0	X13	t	PoS	\N	2500124
PCS	Pabyosi Coin	X11	t	PoW/PoS	\N	31500000000
NBIT	NetBit	Scrypt	t	PoW/PoS	\N	10.500.000
WINE	WineCoin	Scrypt	t	PoW/PoS	\N	1744000000
ARK	ARK	DPoS	t	DPoS	108202084	125000000
ZECD	ZCashDarkCoin	Scrypt	t	PoW	\N	500000000
WASH	WashingtonCoin	X11	t	PoW/PoS	\N	170000000
LUCKY	LuckyBlocks	PoS	t	PoS	\N	20000000
INSANE	InsaneCoin	X11	t	PoW/PoS	18342813	30000000
BASH	LuckChain	Scrypt	t	PoW/PoS	0	1000000000
FAME	FameCoin	QuBit	t	PoW/PoS	\N	50000000
LIV	LiviaCoin	Scrypt	t	PoW/PoS	\N	1572000000
DOGETH	EtherDoge	X11	t	PoW/PoS	\N	18100000
KLC	KiloCoin	Scrypt	t	PoW	196297971	10000000000
HUSH	Hush	Equihash	t	PoW	0	21000000
BTLC	BitLuckCoin	PoS	t	PoS	\N	5000000000
DRM8	Dream8Coin	Scrypt	t	PoW	\N	88800000000
EBZ	Ebitz	PoS	f	PoS	\N	21000000
FGZ	Free Game Zone	Scrypt	t	PoW	\N	44775520
BOSON	BosonCoin	X11	t	PoW/PoS	\N	5000000000
ATX	ArtexCoin	X11	t	PoW	824000000	500000000
PNC	PlatiniumCoin	SHA-256	t	PoW	\N	21000000
BRDD	BeardDollars	Scrypt	t	PoW/PoS	\N	21212121
BIPC	BipCoin	CryptoNight	t	PoW	\N	18446744
XNC	XenCoin	Scrypt	t	PoW	\N	2100000000
EMB	EmberCoin	X13	t	PoW/PoS	92192822723	850000000
BTTF	Coin to the Future	PoS	t	PoS	\N	1210000
DLR	DollarOnline	X11	t	PoW/PoS	\N	1000000000
XEN	XenixCoin	X11	t	PoW/PoS	3853326.777	3853326.777
IW	iWallet	X11	t	PoW/PoS	\N	2142857143
FRE	FreeCoin	PoS	t	PoS	50000000	50000000
NPC	NPCcoin	SHA-256D	t	PoW/PoS	0	7000000000
PLNC	PLNCoin	Scrypt	t	PoW/PoS	17089600	38540000
DGMS	Digigems	Scrypt	t	PoW	\N	50000000
ICOB	Icobid	Scrypt	t	PoW/PoS	0	200000000
ARCO	AquariusCoin	Scrypt	t	PoW/PoS	2449577.415	42000000
KURT	Kurrent	X11	t	PoW	61364813	228000000
XCRE	Creatio	PoS	t	PoS	20000000	20000000
ENT	Eternity	X11	t	PoW/PoS	6069482.077	60000000
MTLM3	Metal Music v3	Scrypt	f	PoW/PoS	\N	2500000000
ODNT	Old Dogs New Tricks	SHA-256D	t	PoW/PoS	\N	21000000
EUC	Eurocoin	SHA-256	t	PoW/PoS	12416554	20000000
CCX	CoolDarkCoin	Scrypt	t	PoW/PoS	\N	11052632
BCF	BitcoinFast	Scrypt	t	PoW/PoS	20244023.64	33000000
SEEDS	SeedShares	SHA-256D	t	PoW/PoS	\N	7996400
XSN	Stakenet	X11	t	TPoS	75590369	76500000
BCCOIN	BitConnect Coin	Scrypt	t	PoW/PoS	11080722.38	28000000
SHORTY	ShortyCoin	PoS	t	PoS	\N	100000000
PCM	Procom	Scrypt	t	PoW	\N	28000000
CORAL	CoralPay	X13	t	PoS	\N	21000000
MONEY	MoneyCoin	Scrypt	t	PoW/PoS	10914418	650659833
HSP	Horse Power	Scrypt	t	PoW	\N	2900000
HZT	HazMatCoin	Scrypt	t	PoW/PoS	\N	100000000
CRSP	CryptoSpots	DPoS	t	DPoS	\N	0
ICON	Iconic	PoS	t	PoS	\N	520000
NIC	NewInvestCoin	PoS	t	PoS	\N	47090909
ACN	AvonCoin	PoS	t	PoS	\N	1000000000
XNG	Enigma	X11	t	PoW/PoS	814671	5000000
XCI	Cannabis Industry Coin	CryptoNight	t	PoW	978145	21000000
LOOK	LookCoin	X11	t	PoW/PoS	\N	1613150000
MIS	MIScoin	X11	t	PoW/PoS	\N	25000000
WOP	WorldPay	X11	t	PoW/PoS	\N	10000000
CQST	ConquestCoin	X13	t	PoW/PoS	\N	30000000
CHIEF	TheChiefCoin	Scrypt	t	PoW/PoS	\N	2500000000
RC	Russiacoin	Scrypt	t	PoW/PoS	8377873	144000000
PND	PandaCoin	Scrypt	t	PoS	33813143822	32514916898
ECAD	Canada eCoin	Scrypt	t	PoW	\N	100000000
OPTION	OptionCoin	X11	t	PoS	\N	21000000
AV	Avatar Coin	PoS	t	PoS	\N	10000000
LTD	Limited Coin	PoS	t	PoS	\N	128
UNITS	GameUnits	Scrypt	t	PoW/PoS	3472983	13000000
GAKH	GAKHcoin	Scrypt	t	PoW/PoS	3315789	3315789
S8C	S88 Coin	Scrypt	t	PoW/PoS	\N	520000000
ASAFE2	Allsafe	Quark	t	PoS	10517772.74	15000000
LTCR	LiteCreed	QuBit	t	PoW/PoS	30227750	78835200
XPRO	ProCoin	X15	t	PoW/PoS	\N	6000000
ASTR	Astral	X13	t	PoW/PoS	\N	37875500
GIFT	GiftNet	X13	t	PoW	\N	6750000
VIDZ	PureVidz	PoS	t	PoS	\N	125000000
INC	Incrementum	PoS	t	PoS	\N	1300000
PTA	PentaCoin	SHA-256	t	PoW/PoS	\N	1311955
ACID	AcidCoin	SHA-256	t	PoW	\N	4500000000
RNC	ReturnCoin	X11	t	PoS	\N	250000000
TWIST	TwisterCoin	X11	t	PoW/PoS	\N	3195000
PAYP	PayPeer	X11	t	PoW/PoS	\N	50000000000
LENIN	LeninCoin	SHA-256D	t	PoW	\N	100000000
MRSA	MrsaCoin	X13	t	PoW/PoS	\N	2100000000
OS76	OsmiumCoin	Scrypt	t	PoW	894026	2714286
BIC	Bikercoins	CryptoNight	t	PoW	9357088	25000000
CRPS	CryptoPennies	X11	t	PoS	\N	1593.15
NTCC	NeptuneClassic	X11	t	PoW/PoS	0	250000000
HXX	HexxCoin	Lyra2RE	t	PoW	1876146.444	9999999
SPKTR	Ghost Coin	SHA-256	t	PoW/PoS	\N	2270000
MAC	MachineCoin	Time Travel	t	PoW	\N	35000000
SEL	SelenCoin	PoS	t	PoS	\N	159680000
NOO	Noocoin	PoS	t	PoS	\N	25000000
CHAO	23 Skidoo	SHA-256D	t	PoW	\N	23
XGB	GoldenBird	X13	t	PoW/PoS	0	450000000
YMC	YamahaCoin	Scrypt	t	PoW	\N	315000000
JOK	JokerCoin	Scrypt	t	PoW/PoS	\N	5000000000
GBIT	GravityBit	Scrypt	t	PoW/PoS	\N	5333000
TEC	TeCoin	Multiple	t	PoW	\N	469521976
BOMBC	BombCoin	Scrypt	t	PoW/PoS	\N	4516129032
RIDE	Ride My Car	PoS	t	PoS	0	100000000
KED	Klingon Empire Darsek	Scrypt	t	PoW/PoS	23965372	500000000
IOP	Internet of People	SHA-256	t	PoW/PoS	2526078.475	21000000
ELS	Elysium	Scrypt	t	PoW	\N	18000000
KUSH	KushCoin	X11	t	PoW/PoS	5659096.957	9354000
ERY	Eryllium	X11	t	PoW/PoS	0	100000000
OPES	Opes	Argon2	t	PoW	\N	52000000
RATIO	Ratio	PoS	t	PoS	\N	100000000
SMF	SmurfCoin	Scrypt	t	PoW/PoS	\N	2500000000
TECH	TechCoin	X13	t	PoW/PoS	\N	300000
CIR	CircuitCoin	SHA-256D	t	PoW/PoS	\N	3125000000
LEPEN	LePenCoin	SHA-256	t	PoS	\N	1000000000
MARX	MarxCoin	X11	t	PoW	0	100640000
HAZE	HazeCoin	Scrypt	t	PoW	\N	25000000
PRX	Printerium	Scrypt	t	PoW/PoS	11821728	20000000
PAC	PacCoin	X11	t	PoW	536982074	100000000000
IMPCH	Impeach	Scrypt	t	PoW/PoS	308179	21933333
ERR	ErrorCoin	Scrypt	t	PoW	\N	81000000
TIC	TrueInvestmentCoin	Scrypt	t	PoW/PoS	\N	53200000
NUKE	NukeCoin	PoS	t	PoS	\N	2778196
SFC	Solarflarecoin	Scrypt	t	PoW	0	20000000
JANE	JaneCoin	X11	t	PoW/PoS	\N	2100000000
PARA	ParanoiaCoin	Scrypt	t	PoW	\N	72000000
MM	MasterMint	X11	t	PoS	\N	1500000000
CTL	Citadel	CryptoNight-V7	t	PoW	10969318.52	185000000
ZBC	Zilbercoin	Scrypt	t	PoS	2922613.964	55000000
FRST	FirstCoin	Scrypt	t	PoW/PoS 	110000000	110000000
ORO	OroCoin	Scrypt	t	PoW	\N	23529412
ALEX	Alexandrite	SHA-256	t	PoW/PoS	\N	1268000
TBCX	TrashBurn	SHA-256D	t	PoS	\N	9000000
MCAR	MasterCar	Scrypt	t	PoW/PoS	\N	2991837
THS	TechShares	DPoS	t	DPoS	\N	600000000
ACES	AcesCoin	X13	t	PoS	\N	100000000
UAEC	United Arab Emirates Coin	X11	f	PoW/PoS	\N	10000000
EA	EagleCoin	SHA-256	t	PoW	\N	40000000
CREA	CreativeChain	Keccak	t	PoW	0	115000000
BVC	BeaverCoin	Scrypt	t	PoW	3115258	3360000
FIND	FindCoin	X13	t	PoS	14524851.48	14524851.48
MLITE	MeLite	SHA-256D	t	PoW/PoS	\N	1.000.000
STALIN	StalinCoin	X11	t	PoW/PoS	\N	3000000000
TSE	TattooCoin	Scrypt	t	PoW/PoS	\N	500000000
VLTC	VaultCoin	X11	t	PoW	30385540	1000000000
BIOB	BioBar	SHA-256D	t	PoW/PoS	\N	60000000
ZER	Zero	Equihash	t	PoW	6921653.9	17000000
CHAT	OpenChat	Scrypt	t	PoW/PoS	1000000000	1000000000
CDN	Canada eCoin	Scrypt	t	PoW	99843408.32	100000000
ZOI	Zoin	Lyra2RE	t	PoW	18545757.5	21000000
HONEY	Honey	Blake2S	t	PoW/PoS	\N	7000000
MXT	MartexCoin	X13	t	 PoW/PoS	\N	5000000
MUSIC	Musicoin	Ethash	t	PoW	0	454898394
VEG	BitVegan	PoS	t	PoS	\N	600000000
MBIT	Mbitbooks	Scrypt	t	PoW	\N	81000000
ZENI	Zennies	Scrypt	t	PoS	\N	1000000000
PLANET	PlanetCoin	Scrypt	t	PoW/PoS	\N	1000000
DUCK	DuckDuckCoin	Scrypt	t	PoW	\N	121
BNX	BnrtxCoin	X11	t	PoW	0	210000000
RNS	RenosCoin	Scrypt	t	PoS	36050365	34426423
DBIX	DubaiCoin	Dagger-Hashimoto	t	PoW	2232901	2232901
XVP	VirtacoinPlus	X11	t	PoW/PoS	13162749.09	100000000
BOAT	Doubloon	536	t	PoW/PoS	\N	500000000
TAJ	TajCoin	Blake2S	t	PoW/PoS	12184195.93	36900000
IMX	Impact	X11	t	PoW/PoS	110630387.9	110000000
CJC	CryptoJournal	PoS	t	PoS	\N	100000000
AMY	Amygws	Scrypt	t	PoW	\N	23333333
QBT	Cubits	SHA-256	t	PoW/PoS	\N	300000000
EB3	EB3coin	Scrypt	t	PoW	64096052	4000000000
XVE	The Vegan Initiative	PoS	t	PoS	\N	50000000
APT	Aptcoin	Scrypt-n	t	PoW	\N	42000000
BLAZR	BlazerCoin	Scrypt	t	PoW	\N	294336000
UNI	Universe	Scrypt	t	PoS	0	112000000
ECOC	ECOcoin	Scrypt	t	PoW/PoS	\N	10733333
DARK	Dark	SHA-256	t	PoW/PoS	\N	12800000
DON	DonationCoin	Scrypt	t	PoW	\N	90000000
ATMOS	Atmos	PoS	t	PoS	111135836.9	110290030
HPC	HappyCoin	X11	t	PoW/PoS	21521322.01	100000000
CXT	Coinonat	NIST5	t	PoW	10123200	48252000
MCRN	MacronCoin	PoS	t	PoS	401421401	400000000
RAIN	Condensate	X11	t	PoW/PoS	121665451.6	500000000
IEC	IvugeoEvolutionCoin	Scrypt	t	PoW	\N	100000000
IMS	Independent Money System	Scrypt	t	PoW/PoS	5368934	21212121
ARGUS	ArgusCoin	Scrypt	t	PoW/PoS	1148324	28600000
LMC	LomoCoin	Scrypt	t	PoW/PoS	500000	1000000000
BTCS	Bitcoin Scrypt	Scrypt	t	PoW	0	21000000
PROC	ProCurrency	SHA-256	t	PoS	100545745	75000000000
XGR	GoldReserve	X11	t	PoW/PoS	17171382	40000000
BENJI	BenjiRolls	Scrypt	t	PoW	20276099.15	35520400
DUO	ParallelCoin	Scrypt	t	PoW	0	1000000
GRW	GrowthCoin	Scrypt	t	PoS	295135466.4	2000000000
ILC	ILCoin	SHA-256	t	PoW	1317747500	2500000000
PZM	Prizm	SHA-256	t	PoS	\N	600000000000000
PHR	Phreak	PoS	t	PoS	11390225.97	30000000
PUPA	PupaCoin	Blake2S	t	PoW/PoS	\N	3500000000
RICE	RiceCoin	X13	t	PoW/PoS	\N	10000000
XCT	C-Bits	SHA-256	t	PoW	\N	210000000
DEA	Degas Coin	Scrypt	t	PoW/PoS	21358764	105000000
ZSE	ZSEcoin	X11	t	PoW/PoS	0	2093500000
TAP	TappingCoin	X11	t	PoW/PoS	\N	5000000000
MUU	MilkCoin	SHA-256	t	PoW/PoS 	\N	4500000000
INF8	Infinium-8	CryptoNight	f	PoW	\N	0
HTML5	HTML5 Coin	X15	t	PoW/PoS	40659020000	90000000000
SBSC	Subscriptio	PoS	t	PoS	\N	10000000
USC	Ultimate Secure Cash	SHA-256	t	PoS	10343113	200084200
DUX	DuxCoin	Scrypt	t	PoW/PoS	\N	1680000000
XPS	PoisonIvyCoin	Scrypt	t	PoW/PoS	\N	4666666667
EQT	EquiTrader	Scrypt	t	PoW	13673406.43	72000000
MNTC	Manet Coin	Scrypt	t	PoW/PoS	\N	215000000
HAMS	HamsterCoin	Scrypt	t	PoW	\N	20000000
QTUM	QTUM	POS 3.0	t	PoS	100000000	100000000
NEF	NefariousCoin	Scrypt	t	PoW/PoS	\N	4835000000
QRL	Quantum Resistant Ledger	CryptoNight-V7	t	PoW	69036016.83	105000000
ESP	Espers	536	t	PoW/PoS	22801882871	50000000000
DYN	Dynamic	Argon2d	t	PoW	19784224.65	0
NANO	Nano	Blake2b	t	PoW	133248297	340282367
CHAN	ChanCoin	Cloverhash	t	PoW	18407259.09	30000000
DCY	Dinastycoin	CryptoNight	t	PoW	1809467143	2000000000
DNR	Denarius	NIST5	t	PoW/PoS	4171382	10000000
DP	DigitalPrice	X11	t	PoW	35138975	100000000
VUC	Virta Unique Coin	NIST5	t	PoW/PoS	62942075	120000000
BTPL	Bitcoin Planet	Skein	t	PoW/PoS	6804362	100000000
UNIFY	Unify	Scrypt	t	PoW	18133195	19276800
BRIT	BritCoin	X13	t	PoW/PoS	21268092	30000000
SOCC	SocialCoin	Scrypt	t	PoW	5167775	75000000
OTX	Octanox	X11	t	PoW/PoS	0	7905634
ARC	ArcticCoin	X11	t	PoW	26042364.37	60000000
BOG	Bogcoin	SHA-256	t	PoW	\N	21212121
SAND	BeachCoin	X11	t	PoW	\N	21000000
DAS	DAS	X11	t	PoW	2622886	18900000
LINDA	Linda	Scrypt	t	PoW/PoS	9044930943	50000000000
XLC	LeviarCoin	CryptoNight	t	PoW	14161803	54000000
ONION	DeepOnion	X13	t	PoW/PoS	21917018.05	18898187.62
BTX	Bitcore	Time Travel	t	PoW	17801865.16	21000000
GCN	gCn Coin	Scrypt	t	PoW	163055000000	200000000000
SMART	SmartCash	Keccak	t	PoW	2241009149	5000000000
SIGT	Signatum	SkunkHash v2 Raptor	t	PoS	107972766	137500000
ONX	Onix	X11	t	PoW	122475638.4	1100000000
WINK	Wink	PoS	t	PoS	\N	80000000
CRM	Cream	Skein	t	PoW/PoS	47331802.48	100000000
BCH	Bitcoin Cash	SHA-256	t	PoW	17995589.65	21000000
BMXT	Bitmxittz	Scrypt	f	PoW/PoS	\N	10000
XMCC	Monoeci	X11	t	PoW/PoS	12569262.54	9507271
CMPCO	CampusCoin	Scrypt	t	PoW	0	1010000000
DFT	Draftcoin	Scrypt	t	PoS	18663297.35	17405891.2
VET	Vechain	VeChainThor Authority	t	Proof of Authority	55454734800	86712634466
SOJ	Sojourn Coin	Scrypt	t	PoW	485214	10500000000
STCN	Stakecoin	PoS	t	PoS	4000000	61599965
NYC	NewYorkCoin	Scrypt	t	PoW	143007000000	0
LBTC	LiteBitcoin	Scrypt	t	PoW	0	1000000000
FRAZ	FrazCoin	Scrypt	t	PoW	9704042	20000000
KRONE	Kronecoin	Scrypt	t	PoW	17453749.4	84000000
ACC	AdCoin	Scrypt	t	PoW	32646731.06	100000000
LINX	Linx	Scrypt	t	PoW	33716526	100000000
XCXT	CoinonatX	Scrypt	t	PoW/PoS	19539588	48252000
BLAS	BlakeStar	Blake2S	t	PoW/PoS	\N	2400000000
ETHD	Ethereum Dark	Scrypt	t	PoW/PoS	4200000	4200000
SUMO	Sumokoin	CryptoNight	t	PoW	8946653	88888888
ODN	Obsidian	SHA-512	t	PoS	25000000	91388946
ADA	Cardano	Ouroboros	t	PoS	25927070538	45000000000
REC	Regalcoin	X11	t	PoW/PoS	7262402.043	27000000
BTCZ	BitcoinZ	Equihash	t	PoW	5211553258	21000000000
NTM	NetM	Scrypt	t	PoW	\N	101319000000
TZC	TrezarCoin	NeoScrypt	t	PoW/PoS	182638400	400000000
ELM	Elements	X11	t	PoW	2702855669	1800000000
TER	TerraNovaCoin	Scrypt	t	PoW/PoS	1140734.917	15733333
VIVO	VIVO Coin	NeoScrypt	t	PoW	4165967.575	27000000
RGC	RG Coin	NIST5	t	PoW/PoS	\N	300000000
RUP	Rupee	Lyra2REv2	t	PoS	24000000	24000000
BTG	Bitcoin Gold	Equihash	t	PoW	17202361.09	21000000
WOMEN	WomenCoin	Scrypt	t	PoW/PoS	48459472454	25000000000
MAY	Theresa May Coin	SHA-256	t	PoW/PoS	92050800	100000000
EDDIE	Eddie coin	Scrypt	t	PoW/PoS	\N	1000000000
NAMO	NamoCoin	NIST5	t	PoW/PoS	560563220	1200000000
LUX	LUXCoin	PHI1612	t	PoW/PoS	8305775.318	60000000
PIRL	Pirl	Dagger	t	PoW	33986980	156306732.7
XIOS	Xios	Scrypt	t	PoW/PoS	2149688	21000000
BTDX	Bitcloud 2.0	Quark	t	PoW/PoS	30711550.53	200000000
EBST	eBoost	Scrypt	t	PoW	99990001.49	100000000
KEK	KekCoin	POS 2.0	t	PoS	12330806.31	21000000
BLHC	BlackholeCoin	Scrypt	t	PoW/PoS	16362544.99	14788275.99
ALTCOM	AltCommunity Coin	SkunkHash	t	PoW/PoS	0	5000000
PURE	Pure	X11	t	PoW/PoS	0	3686860
RUPX	Rupaya	Quark	t	PoS	0	75000000
XIN	Infinity Economics	SHA-256	t	PoS	8999999990	9000000000
HNCN	Huncoin	X13	f	PoW	\N	86400000
MADC	MadCoin	Scrypt	t	PoW	\N	10000000
PURA	Pura	X11	t	PoW	175215859	350000000
INN	Innova	NeoScrypt	t	PoW	6375259.04	45000000
BDL	Bitdeal	Scrypt	t	PoW	0	300000000
WSC	WiserCoin	Scrypt	f	PoW	\N	22105263
MSR	Masari	CryptoNight	t	PoW	\N	18500000
ELLA	Ellaism	Ethash	t	PoW	12756367	280000000
SKR	Sakuracoin	Scrypt	t	PoW	0	105100000
ISH	Interstellar Holdings	Scrypt	f	PoS	0	1970000000
GBX	GoByte	NeoScrypt	t	PoW	5832306.875	31800000
CSTL	Castle	Quark	t	DPoS	0	50000000
ICC	Insta Cash Coin	SHA-256	f	PoW	0	300000000
ALQO	Alqo	Quark	f	PoW/PoS	65269530.1	57879300
KNGN	KingN Coin	Scrypt	f	PoW/PoS	\N	420000
MAG	Magnet	X11	t	PoW/PoS	38198594.83	144000000
TAU	Lamden Tau	DPoS	t	DPoS	288090567.5	500000000
ECA	Electra	NIST5	t	PoW/PoS	28399150208	30000000000
BCD	Bitcoin Diamond	X13	t	PoW/PoS	183534024.9	210000000
VOT	Votecoin	Equihash	t	PoW	\N	220000000
XSH	SHIELD	Multiple	t	PoW	481730566.6	660000000
BCO*	BridgeCoin	Scrypt	f	PoW	0	27000000
DSR	Desire	NeoScrypt	t	PoW	\N	22000000
MUT	Mutual Coin	Scrypt	f	PoW/PoS	0	1000000000
CNBC	Cash & Back Coin	Scrypt	t	PoW/PoS	110976977.3	210000000
XUN	UltraNote	CryptoNight	t	PoW	19281821413	85000000000
MAN	People	Scrypt	t	PoW	\N	7500000000
ACHN	Achain	DPoS	t	DPoS	\N	1000000000
NRO	Neuro	SHA-256	f	PoW/PoS	\N	20000000
SEND	Social Send	Quark	t	PoW/PoS	\N	150000000
COAL	BitCoal	CryptoNight	t	PoW	4500000	12500000
DAXX	DaxxCoin	Ethash	t	PoW	520891780	10000000000
BWK	Bulwark	NIST5	t	PoS	13247178.88	27716121
BOXY	BoxyCoin	Scrypt	f	PoW	5761512.81	100000000
SBTC	Super Bitcoin	SHA-256	t	PoW	\N	21210000
KLKS	Kalkulus	Quark	t	PoS	16955764.9	20000000
AC3	AC3	X11	t	PoW	80316207	550000000
CHIPS	CHIPS	SHA-256	t	PoW	0	21000000
LTHN	Lethean	CryptoNight-V7	t	PoW	441250233.4	999481516
GER	GermanCoin	Scrypt	t	PoW/PoS	4911500269	50000000000
LTCU	LiteCoin Ultra	Scrypt	t	PoW/PoS	8419402.321	150000000
STAK	Straks	Lyra2REv2	t	PoW	\N	150000000
POP	PopularCoin	Scrypt	t	PoW	3964201249	4999999999
PNX	PhantomX	X11	t	PoW/PoS	45174214.11	50000000
HBC	HomeBlockCoin	X11	f	PoW/PoS	0	28000000
HTML	HTML Coin	SHA-256	t	PoW/PoS	0	90000000000
PHO	Photon	BLAKE256	t	PoW	30089671531	90000000000
SUCR	Sucre	X11	t	PoW	4229040.504	19800000
ACCO	Accolade	Scrypt	f	PoW/PoS	5573908	50000000
CPN	CompuCoin	Scrypt	t	PoW	\N	35000000
XFT	Fantasy Cash	Scrypt	t	PoW/PoS	0	4600000
OMGC	OmiseGO Classic	Scrypt	f	PoW/PoS	49933217.75	70000000
ORE	Galactrum	Lyra2REv2	t	PoW/PoS	\N	26280000
SPK	SparksPay	NeoScrypt	t	PoW	7847417.334	21000000
GOA	GoaCoin	NeoScrypt	f	PoW	3982139.246	32000000
WAGE	Digiwage	Quark	t	PoS	27299680	120000000
GUN	GunCoin	NeoScrypt	t	PoW	299797953	500000000
POLIS	PolisPay	X11	t	PoW	\N	25000000
IRL	IrishCoin	Scrypt	t	PoW	45483049.34	64000000
TROLL	Trollcoin	Scrypt	t	PoW/PoS	591022748	900000000
LCP	Litecoin Plus	Scrypt	t	PoW/PoS	2504486.228	4000000
TGCC	TheGCCcoin	X13	t	PoW/PoS	\N	2400000000
MONK	Monkey Project	X11	t	PoS	4407252	21000000
KZC	KZCash	X11	t	PoW	\N	18000000
WCG	World Crypto Gold	SHA-256	t	Proof of Stake	\N	900000000
ECC	ECC	Scrypt	f	PoS	25000000000	25000000000
STN	Steneum Coin	Scrypt	t	PoW	\N	20000000
PCOIN	Pioneer Coin	X11	t	PoW	8478104.34	23000000
UBTC	UnitedBitcoin	SHA-256	t	PoW	20166000	20166000
ITZ	Interzone	C11	t	PoW	11916588.09	23000000
XBP	Black Pearl Coin	X13	t	PoW/PoS	\N	50000000
SGL	Sigil	NeoScrypt	f	PoW	0	50000000
OPC	OP Coin	Scrypt	t	PoW/PoS	0	2000000000
SHA	Shacoin	SHA-256	t	PoS	\N	350000000
BTW	BitWhite	DPoS	t	DPoS	\N	60000000
CROAT	Croat	CryptoNight	t	PoW	\N	100467441
VAL	Valorbit	Scrypt	t	PoW/PoS	0	9.22337E+16
TPAY	TokenPay	POS 3.0	t	PoS	20445861.53	25000000
CVNG	Crave-NG	SHA-256	t	PoS	\N	1000000000
MCT	1717 Masonic Commemorative Token	Ethash	t	PoS	1618033	1618033
CWIS	Crypto Wisdom Coin	Scrypt	f	PoW	17630550.21	24000000
MBC	My Big Coin	Scrypt	t	PoW and PoS	9399342.528	30000000
WOBTC	WorldBTC	Scrypt	f	PoW/PoS	\N	210000000
TRTL	TurtleCoin	CryptoNight	t	PoW	53139835214	1000000000000
NDLC	NeedleCoin	X11	f	PoS/PoW	\N	120000000
MUN	MUNcoin	SkunkHash	t	PoW	4818338.989	16600000
USX	Unified Society USDEX	Scrypt	t	PoW/PoS	234846265.8	232000000
BCA	Bitcoin Atom	SHA-256	t	PoW/PoS	\N	21000000
B2X	SegWit2x	X11	t	PoW/PoS	\N	21000000
NBR	Niobio Cash	CryptoNight	t	PoW	133932467.8	336000000
SCOOBY	Scooby coin	Scrypt	t	PoW/PoS	\N	21000000
BUN	BunnyCoin	Scrypt	t	PoW	\N	100000000000
BSR	BitSoar Coin	X11	f	PoS	3680297312	3980000000
SKULL	Pirate Blocks	X11	t	PoW/PoS	\N	240000000
BTCP	Bitcoin Private	Equihash	t	PoW	0	21000000
SKC	Skeincoin	Skein	t	PoW	0	17000000
KRM	Karma	Groestl	t	PoS	\N	3000000000
CDY	Bitcoin Candy	Equihash	t	PoW	\N	21000000000
SSS	ShareChain	Scrypt	t	PoW	10000000000	10000000000
CRDNC	Credence Coin	SHA-256	f	PoW/PoS	3427006	25000000
TRF	Travelflex	Dagger	t	PoW	107325266	100000000
KREDS	KREDS	Lyra2REv2	t	PoW	643795911.5	1100000000
VULC	Vulcano	NIST5	t	PoS/PoW	\N	421126225
TOKC	Tokyo Coin	X13	t	PoS	230298925	800000000
BBP	BiblePay	Proof-of-BibleHash	t	POBh	1772091550	5200000000
LCC	LitecoinCash	SHA-256 + Hive	t	PoW + Hive	638382332.2	840000000
FLIP	BitFlip	Scrypt	t	PoW	12446100	40000000
LOT	LottoCoin	Scrypt	t	PoW	14491014421	18406979840
FUNK	Cypherfunks Coin	Scrypt	t	PoW	\N	49275000000
LEAF	LeafCoin	Scrypt	t	PoW	0	21000000000
BASHC	BashCoin	Skein	f	PoW/PoS	11661844.47	72000000
DGM	DigiMoney	X11	f	PoW/PoS	3521630	25000000
CBS	Cerberus	NeoScrypt	t	PoW	0	31500000
BTCH	Bitcoin Hush	Equihash	t	PoW	0	21000000
LIZ	Lizus Payment	Skein	f	PoW/PoS	2985971	69000000
CIF	Crypto Improvement Fund	X11	t	PoW	211297638.5	500000000
SPD	Stipend	C11	t	PoW/PoS	11251342.19	19340594
POA	Poa Network	Proof-of-Authority	t	PoA	204479039	252460800
PUSHI	Pushi	X11	t	PoW/PoS	2167827.1	25000000
POKER	PokerCoin	Scrypt	f	PoS/PoW	0	466666667
ELP	Ellerium	XEVAN	t	PoW/PoS	419275.38	60000000
VLX	Velox	Scrypt	t	PoS	25570013.13	124000000
ONT	Ontology	VBFT	t	PoS	650848625	1000000000
CLO	Callisto Network	Ethash	t	PoW	247612453	6500000000
CRU	Curium	X11	t	PoW	0	22000000
ELIC	Elicoin	YescryptR16	t	PoW	\N	10000000
TUBE	BitTube	CryptoNight	t	PoW	80049082.91	1000000000
DIN	Dinero	NeoScrypt	t	PoW	0	100000000
PSD	Poseidon	Scrypt	t	PoW	4070212.149	21000000
LELE	Lelecoin	Curve25519	t	PoS	\N	1000000000
AKA	Akroma	Ethash	t	PoW	\N	100000000
MANNA	Manna	SHA-256	f	PoW	2360478329	10044655076
ADK	Aidos Kuneen	IMesh	t	PoW	25000000	25000000
SERA	Seraph	PHI1612	f	PoW/PoS	1360250	32000000
AET	AfterEther	Ethash	f	PoW	\N	200000000
CMOS	Cosmo	Quark	f	PoW	8928876.686	11892000
REDN	Reden	X16S	f	PoW	0	14000000
TLP	TulipCoin	Scrypt	t	PoW/PoS	\N	5250000000
BSX	Bitspace	NIST5	t	PoW/PoS	13787854.63	50000000
FNO	Fonero	PHI1612	t	PoW	\N	18400000
XSG	Snowgem	Equihash	t	PoW	0	84096000
CVTC	CavatCoin	DPoS	f	DPoS	\N	21000000
XTL	Stellite	CryptoNight	f	PoW	\N	21000000000
BRIA	Briacoin	Scrypt	t	PoW/PoS	845637.8135	3000000
IC	Ignition	Scrypt	t	PoW/PoS	1182153.5	5000000
MNB	MoneyBag	X11	f	PoS	\N	50000000
BTL	Bitrolium	Equihash	t	PoW	71355477	70000000
BCI	Bitcoin Interest	Equihash	t	PoW	0	22300000
MEDIC	MedicCoin	Scrypt	t	PoS	267297676.3	500000000
FLM	FOLM coin	PHI1612	f	PoW	0	23001916
ALPS	Alpenschillling	Lyra2Z	t	PoW	27340501.65	300000000
ZEL	Zelcash	Equihash	t	PoW/PoS	0	210000000
BITG	Bitcoin Green	Green Protocol	t	PoS	9803691.362	21000000
DEV	Deviant Coin	PoS	t	PoS	21876586.85	88000000
ABJ	Abjcoin	Scrypt	t	PoW/PoS	9880502.372	30000000
RAP	Rapture	NeoScrypt	f	PoW	4478901.292	21000000
ANI	Animecoin	Quark	t	PoW	\N	1976000000
PHC	Profit Hunters Coin	Scrypt	t	PoW/PoS	0	100000000
SEM	Semux	Semux BFT consensus	t	DPoS	1231147	100000000
BBK	BitBlocks	Scrypt	t	PoW/PoS	0	500000000
UWC	Uwezocoin	Scrypt	f	PoW	0	840000000
FTO	FuturoCoin	X11	t	PoW	31801461.19	100000000
CARE	Carebit	Quark	t	PoW/PoS	139739596.5	200000000
NZL	Zealium	PoS	t	PoS	11075254.09	80000000
XMC	Monero Classic	CryptoNight	t	PoW	16016864	18400000
TIPS	FedoraCoin	Scrypt	t	PoW	\N	500000000000
CHARM	Charm Coin	NeoScrypt	t	PoW	\N	250000000
PROTON	Proton	X16R	t	PoS	4403800	45000000
DERO	Dero	CryptoNight	t	PoW	\N	18400000
DEAL	iDealCash	Scrypt	t	PoW/PoS	1404157529	5121951220
JUMP	Jumpcoin	NIST5	t	PoW	21069346.25	21000000
INFX	Infinex	Lyra2RE	t	PoW	5097689.711	26280000
XBI	Bitcoin Incognito	XEVAN	t	PoS/PoW	10904963.09	21000000
KEC	KEYCO	Tribus	t	PoW	795447	18000000
SABR	SABR Coin	Scrypt	t	PoW/PoS	\N	133100000
HWC	HollyWoodCoin	Scrypt	t	PoS	38706809.47	26000000
GIN	GINcoin	Lyra2Z	t	PoW	6986399.704	10500000
XMV	MoneroV	CryptoNight	t	PoW	\N	256000000
PAR	Parlay	Scrypt	f	PoS	3783270	30000000
LTCC	Listerclassic Coin	Scrypt	f	PoW/PoS	8094818.389	110000000
AMX	Amero	NeoScrypt	t	PoW/PoS	\N	15000000
PLTC	PlatinCoin	CryptoNight	t	PoW	84300	600000518
KNG	BetKings	X11	f	PoS	11359634.65	8148139
COG	Cognitio	SHA-256D	f	PoW/PoS	658584.4616	7500000
BEN	BitCOEN	SHA-256	t	Limited Confidence Proof-of-Activity 	\N	100000000
LOKI	Loki	CryptoNight Heavy	t	PoW	19153632	150000000
NCP	Newton Coin	CryptoNight	t	PoW	41294520017	184000000000
STAX	Staxcoin	Scrypt	t	PoW/PoS	\N	43500000
MRN	Mercoin	Scrypt	f	PoW/PoS	25330252.32	100000000
SIC	Swisscoin	Scrypt	t	PoW/PoS	10200000000	10200000000
EXCC	ExchangeCoin	Equihash	f	PoW	0	32000000
REL	Reliance	X11	f	PoS	7256580	62000000
BTCN	BitcoiNote	CryptoNight	t	PoW	\N	21000000
XT3	Xt3ch	Scrypt	t	PoS	7630000.015	44000000
MGD	MassGrid	Jump Consistent Hash	t	PoW	135862416	168000000
VIG	TheVig	SHA-256D	t	PoW/PoS	33238183.72	100000000
PLURA	PluraCoin	CryptoNight	t	PoW	560085952.4	1000000000
EMAR	EmaratCoin	Scrypt	t	PoW/PoS	21599339.67	84000000
XTNC	XtendCash	Wild Keccak	f	PoW	\N	100000000
ROE	Rover Coin	X11	t	PoW/PoS	\N	60000000
LTCP	LitecoinPro	Scrypt	t	PoW	\N	17500000
DKD	Dekado	X15	t	PoS	30284196.37	90000000
LYNX	Lynx	Scrypt	t	HPoW	77872059788	92000000000
POSQ	Poseidon Quark	Quark	t	PoS	2716264.953	650000000
YCE	MYCE	Scrypt	f	PoW/PoS	63613903.88	250000000
ARO	Arionum	SHA-512	f	PoW	60045900	545399000
BWS	BitcoinWSpectrum	SHA-256	t	PoS	57811001	100262205
BTCC	Bitcoin Core	SHA-256	t	PoW	\N	21000000
GOLF	GolfCoin	SHA-256D	f	PoW/PoS	0	1713134800
MUSE	Muse	DPoS	t	PoS	18194936	18081806
XMN	Motion	X16R	t	PoW	8125865.021	22075700
PLUS1	PlusOneCoin	HMQ1725	t	PoW	8645406.168	21000000
AXE	Axe	X11	t	PoW	4993030.697	21000000
GMCN	GambleCoin	Scrypt	f	PoS	8240763.495	15600000
TRVC	Trivechain	X16R	t	PoW/PoS	36923120.62	82546564
DTEM	Dystem	Quark	t	PoS	7082392.247	21000000
GIC	Giant	Quark	t	PoW/PoS	5919489.768	5151000
PNY	Peony Coin	Scrypt	t	PoS	1042012.452	16880000000
SAFE	SafeCoin	Zhash	t	PoW/PoS	0	36000000
ABS	Absolute Coin	Lyra2REv2	t	PoW/PoS	13332617.94	52500000
VITAE	Vitae	Quark	t	PoS	66053877.63	100000000
BSPM	Bitcoin Supreme	Scrypt	t	PoS	\N	21000000
XGS	GenesisX	XEVAN	f	PoS	0	19000000
BIM	BitminerCoin	CryptoNight	f	PoW	0	50000000
HEX	HexCoin	Scrypt	t	PoW	1416663.066	22105263
DEI	Deimos	Scrypt	f	PoW	269143950.6	1000000000
TPC	TPCash	Scrypt	t	PoW/PoS	5403802.496	1000000000
OYS	Oyster Platform	X11	f	PoS	\N	25000000
WEBC	Webchain	CryptoNight-V7	t	PoW	15580199.31	1750000000
RYO	Ryo	Cryptonight-GPU	t	PoW	4890897	88188888
MUSD	MUSDcoin	Scrypt	t	PoW/PoS	0	100000000
URALS	Urals Coin	XEVAN	t	PoW	14746153.1	210000000
QWC	Qwertycoin	CryptoNight Heavy	t	PoW	99553110529	184470000000
BITN	Bitcoin Nova	CryptoNight	f	PoW	484454200	1000000000
ARE	ARENON	X11	t	PoS	19269509.94	55000000
DACASH	DACash	X11	f	PoW	26709236.76	50000000
EUNO	EUNO	X11	t	PoW/PoS	30771125.98	50000000
MMO	MMOCoin	Scrypt	t	PoS	107763867.9	260000000
DASC	DasCoin	DPoS	t	DPoS	\N	8589934592
KETAN	Ketan	PoS	t	PoS	9327131.597	210000000
NIX	NIX	Lyra2REv2	t	PoW	0	175000000
ITA	Italocoin	CryptoNight Heavy	f	PoW	\N	18446744
XSTC	Safe Trade Coin	Scrypt	t	PoS	0	840000000
PPAI	Project Pai	SHA-256	t	PoW	2100000000	2100000000
MBLC	Mont Blanc	Scrypt	t	PoS	0	70000000
XDNA	XDNA	Keccak	t	PoW/PoS	4672513.844	366000000
PAXEX	PAXEX	X11	t	PoS	4504639	100000000
DIT	Ditcoin	CryptoNight	t	PoW	\N	37000000
AZART	Azart	X11	t	PoW	5015881.373	25000000
AOP	Averopay	Tribus	f	PoW/PoS	1859475.61	36500000
XAP	Apollon	Quark	t	PoW/PoS	0	250000000
TSC	ThunderStake	Scrypt	t	PoW/PoS	1059954080	18000000000
SPLB	SimpleBank	NeoScrypt	f	PoW/PoS	2381470.978	21000000
HMN	Harvest Masternode Coin	Scrypt	t	PoW/PoS	\N	10000000
KCASH	Kcash	SHA-512	t	Zero-Knowledge Proof	1000000000	1000000000
XCG	Xchange	X16R	t	PoW	9753753.615	100000000
AAC	Acute Angle Cloud	ECC 256K1	t	DPOS	1000000000	1000000000
KST	StarKST	Scrypt	t	PoW	\N	6000000000
AUK	Aukcecoin	Scrypt	t	PoW/PoS	\N	80000000
PLAN	Plancoin	Scrypt	t	PoW/PoS	\N	35000000
TRAID	Traid	NeoScrypt	t	PoW/PoS	0	252000000
TCHB	Teachers Blockchain	Scrypt	t	PoW	\N	160000000
MIODIO	MIODIOCOIN	Scrypt	t	PoW	\N	80000000
LTPC	Lightpaycoin	Quark	t	PoS	\N	21000000
HANA	Hanacoin	Lyra2REv2	f	PoW	\N	122500000
BTV	Bitvote	CryptoNight	t	PoW/PoS	\N	21000000
CRYP	CrypticCoin	Equihash	t	PoW	4235111504	7600000000
BTXC	Bettex coin	XEVAN	t	PoS	6787405.18	50000000
ZEST	ZestCoin	Quark	t	PoW	0	29300000
XCASH	X-CASH	CryptoNight Heavy X	t	PoW	0	100000000000
BRAZ	Brazio	HMQ1725	f	PoW	75579791.71	207000000
ACM	Actinium	Lyra2Z	t	PoW	13634850	84000000
LTZ	Litecoinz	Equihash	t	PoW	\N	84000000
ETHO	ETHER-1	Ethash	t	PoW	0	13666237
TWISTR	TWIST	SHA-512	f	PoS	200000000	200000000
MBTC	MicroBitcoin	Rainforest	t	PoW	\N	210000000000
FOREX	FOREXCOIN	Scrypt	t	PoW	\N	1000000000
BSV	Bitcoin SV	SHA-256	t	PoW	17992514.65	21000000
DACH	DACH Coin	Quark	f	PoS	14303114.67	38000000
AGM	Argoneum	PHI1612	f	PoW	13969583.38	64000000
ARMS	2Acoin	CryptoNight-V7	f	PoW	\N	17910000
BITM	BitMoney	XEVAN	t	Pos	208515864.4	70000000000
B2G	Bitcoiin2Gen	Ethash	t	PoW	0	100000000
AUX	Auxilium	Keccak	f	PoA	\N	300000000
JMC	Junson Ming Chan Coin	X11	t	PoS	17209923728	0
FRED	FREDEnergy	CryptoNight	t	PoW	1867054873	8080000000
ZND	Zenad	Quark	t	POS / MN	0	46000000
NGIN	Ngin	M00N	f	PoW	\N	360000000
GENX	Genesis Network	Equihash	t	PoW	\N	4100000000
VTL	Vertical	Lyra2Z	t	PoW	\N	35000000
C25	C25 Coin	SkunkHash	t	PoW	0	6100000
HERB	HerbCoin	Quark	t	PoW/PoS	35312185.74	54000000
AQUA	Aquachain	Argon2	t	PoW	0	42000000
BBTC	BlakeBitcoin	Blake	f	PoW	20595483.85	21000000
UMO	Universal Molecule	Blake	t	PoW	1578281.313	105120001.4
LIT	Lithium	Blake	t	PoW	15846721.25	25228800
ELT	Electron	Blake	f	PoW	24156921.99	7000000000
XNB	Xeonbit	CryptoNight	t	PoW	\N	18400000
RBTC	Smart Bitcoin	SHA-256	t	PoW	0	20999764
PIRATE	PirateCash	Equihash	t	PoS	13475920	105000000
EXO	Exosis	Exosis	t	PoW	406091.925	21000000
BLTG	Block-Logic	Scrypt	t	PoW	35284717.17	120000000
MIMI	MIMI Money	CryptoNight	f	PoW	\N	1E+18
OWC	Oduwa	Scrypt	t	PoW/PoS	14777549.39	21000000
BEAM	Beam	Equihash	t	PoW	35687520	262800000
GALI	Galilel	Quark	t	PoW/PoS	18265011.25	19035999
ZEX	Zaddex	Equihash	f	PoW	\N	210000000
BTH	Bithereum	Equihash	t	PoW	25150787.5	30886000
ARQ	ArQmA	CryptoNight-lite	t	PoW	\N	50000000
VEO	Amoveo	SHA-256	t	PoW	\N	0
CSPN	Crypto Sports	Quark	t	PoS	1934701.675	13370000
CREDIT	Credit	Scrypt	t	PoW/PoS	30825710000	74800000000
SCRIBE	Scribe Network	Lyra2REv2	f	PoW	6040583.73	32700000
LYTX	LYTIX	QuarkTX	t	PoW/PoS	\N	100000000
SCA	SiaClassic	Blake2b	f	PoW	\N	5000000000
LUNES	Lunes	Leased POS	t	LPoS	\N	150728537.6
SLC	SLICE	QuBit	t	PoW	12925790.42	100000000
DASHP	Dash Platinum	X11	t	PoS	715659.4424	19700000
NSD	Nasdacoin	Scrypt	t	PoW/PoS	20546528.21	84000000
VDL	Vidulum	Equihash1927	t	PoW	0	100000000
BEET	Beetle Coin	XEVAN	t	PoW/PoS	198938144.4	500000000
TTN	Titan Coin	SHA-256D	t	PoW/PoS	896361168	5000000000
AWR	Award	X11	t	PoW/PoS	15420234.54	420000000
BST	BlockStamp	SHA-256	t	PoW	0	105000000
BLAST	BLAST	SHA-256	t	PoW	52293836.63	64000000
ESBC	ESBC	Quark	t	PoS	\N	30000000
VBK	VeriBlock	SHA-256	t	PoW	\N	2100000000
XRC	Bitcoin Rhodium	X13	t	PoW	1170292.5	2100000
GLT	GlobalToken	SHA-256	t	PoW	84613100	168000000
INSN	Insane Coin	X11	t	PoW/PoS	23775960.32	30000000
WRT	WRTcoin	X11	t	PoW	\N	25000000000
ALX	ALAX	DPoS	t	DPoS	1000000000	1000000000
TFC	The Freedom Coin	X11	t	PoS	0	25000000
MPT	Media Protocol Token	Ethash	f	PoW	10000000000	10000000000
AMBER	AmberCoin	X11	t	PoW/PoS	\N	1000000000
LDOGE	LiteDoge	Scrypt	t	PoW/PoS	15318887081	35000000000
BBR	Boolberry	X11	t	PoW	0	18450000
SLR	SolarCoin	Scrypt	t	PoW	55565076.39	98100000000
TRK	TruckCoin	X11	t	PoW/PoS	242574105.2	0
UFO	UFO Coin	NeoScrypt	t	PoW	3824685012	4000000000
ASN	Ascension Coin	QuBit	t	PoW/PoS	0	0
OC	OrangeCoin	Scrypt	t	PoW/PoS	3537150	200000000
GSM	GSM Coin	X11	t	PoW/PoS	\N	1800000
BLC	BlakeCoin	Blake	t	PoW	23356790.15	7000000000
BITS	BitstarCoin	Scrypt	t	PoW/PoS	20576532	54256119
NEOS	NeosCoin	SHA-256	t	PoS	4392258.246	21000000
HYPER	HyperCoin	Scrypt	t	PoW/PoS	9631199.993	0
PINK	PinkCoin	X11	t	PoW/PoS	436353624.5	500000000
FCN	FantomCoin 	CryptoNight	t	PoW	0	18400000
XWT	World Trade Funds	X15	t	PoW/PoS	\N	1000000
CESC	Crypto Escudo	Scrypt	t	PoW	780210700	1000000000
TWLV	Twelve Coin	T-Inside	t	PoW/PoS	\N	0
ADC	AudioCoin	Scrypt	t	PoW/PoS	980732529	10500000000
LOG	Wood Coin	Skein	t	PoW	\N	27625814
XCE	Cerium	SHA-256	t	PoW/PoS	\N	2307925
NKA	IncaKoin	SHA-256	t	PoW/PoS	17939725045	190000000
PIGGY	Piggy Coin	X11	t	PoW/PoS	494240666	1000000000
CRW	Crown Coin	SHA-256	t	PoW	22986929.09	42000000
GEN	Genstake	Scrypt	t	PoW/PoS	60000000	15000000
LTS	Litestar Coin	X11	t	PoW/PoS	\N	120000000
QCN	Quazar Coin	CryptoNight	t	PoW	0	18446744
SMLY	SmileyCoin	Scrypt	t	PoW	29583989323	50000000000
BTQ	BitQuark	Multiple	t	PoW	\N	0
PKB	ParkByte	SHA-256	t	PoW/PoS	0	25000000
HNC	Hellenic Coin	Scrypt	t	PoW	\N	100000000
MI	XiaoMiCoin	Scrypt	t	PoW/PoS	404316475.5	400000000
GRS	Groestlcoin	Groestl	t	PoW	73298203.89	105000000
CPC	CapriCoin	X11	t	PoW/PoS	201364327.4	208000000
CLUB	 ClubCoin	Scrypt	t	PoW/PoS	103621876.2	160000000
RADS	Radium	PoS	t	PoS	3821245.742	9000000
BTA	Bata	Scrypt	t	PoW	5052555.92	5000000
PAK	Pakcoin	Scrypt	t	PoW	69684455.44	182000000
CRB	Creditbit 	X11	t	Proof of Trust	16901016.66	16504333
OK	OKCash	SHA-256	t	PoW/PoS	74676064.95	105000000
LSK	Lisk	DPoS	t	DPoS	120012140	159918400
XHI	HiCoin	Scrypt	t	PoS	10000244678	10008835635
XWC	WhiteCoin	Scrypt	t	PoW/PoS	252005564.2	300000000
DOT	Dotcoin	Scrypt	t	PoW	0	890000000
FSC	FriendshipCoin	NeoScrypt	t	PoW/PoS	1120385.005	60168145
THC	The Hempcoin	Scrypt	t	PoW/PoS	0	300000000
FIII	Fiii	SHA3-256	t	DPoC	-5917977548	5000000000
J	JoinCoin	Multiple	t	PoW	3332922.5	2800000
TRI	Triangles Coin	X13	t	PoW/PoS	140777.7534	120000
RAIZER	RAIZER	SHA-256	f	PoW	\N	1000000000
VOLLAR	Vollar	Equihash+Scrypt	t	PoW	100000000	2100000000
VNTY	VENOTY	Scrypt	f	PoW	\N	94000000
AX	AlphaX	Scrypt	t	PoS	\N	200000000000
SWI	Swinca	Quark	f	PoW/PoS	\N	400000000
TCR	TecraCoin	Lyra2Z	f	PoW	40874452.48	210000000
HCXP	HCX PAY	CryptoNight	f	PoW	\N	2000000000
GEX	Gexan	PHI2	f	PoW/PoS	2233828.13	21000000
EOS	EOS	DPoS	t	DPoS	1020544523	0
AHT	Ahoolee	Ethash	t	PoW	\N	100000000
RCC	Reality Clash	Ethash	t	PoW	24487944.1	24487944
OXY	Oxycoin	DPoS	t	DPoS	1122382283	0
Z2	Z2 Coin	SHA-256	f	PoW	\N	11000000
KAPU	Kapu	DPoS	t	DPoS	\N	115000000
GRFT	Graft Blockchain	CryptoNight	t	PoW/PoS	\N	1844674400
MNZ	Monaize	Equihash	t	PoW/DPoW	\N	257142857
AVE	Avesta	Avesta hash	f	PoW	\N	200000000
XSB	Extreme Sportsbook	X11	f	PoS	\N	3000000
SCRM	Scorum	DPoS	t	DPoS	\N	20000000
LWF	Local World Forwarders	DPoS	t	DPoS	\N	100000000
ILT	iOlite	Ethash	t	PoW	0	1000000000
ADM	Adamant	DPoS	t	DPoS	\N	200000000
UPX	uPlexa	CryptoNight	t	PoW	\N	10500000000
TCH	TigerCash	SHA-256	t	PoS	1000000000	1000000000
LAX	LAPO	Lyra2Z	f	PoW/PoS	11086825523	100000000000
TIP	Tip Blockchain	DPoS	t	PoS	\N	1000000000
DTEP	DECOIN	X11	t	PoS	\N	140000000
WAVES	Waves	Leased POS	t	LPoS	100000000	100000000
PART	Particl	PoS	t	PoS	9283137.556	8634140
SLX	Slate	Slatechain	t	PoW	\N	950000000
SHARD	ShardCoin	Scrypt	f	PoS	24924986.09	900000000
BTT	BitTorrent	TRC10	t	DPoS	989989000000	990000000000
CHI	XAYA	NeoScrypt	t	PoW	\N	77303932
ZILLA	ChainZilla	Equihash	f	DPoW	11000068.27	11000000
NXT	Nxt	PoS	t	PoS/LPoS	1000000000	1000000000
ZEPH	ZEPHYR	SHA-256	t	DPoS	1999999995	2000000000
XQN	Quotient	Scrypt	t	PoW/PoS	\N	0
NETC	NetworkCoin	X13	t	PoW/PoS	\N	400000
VPRC	VapersCoin	Scrypt	t	PoW	\N	42750000000
GAP	Gapcoin	Scrypt	t	PoW/PoS	14931046.15	250000000
SERO	Super Zero	Ethash	t	PoW	\N	1000000000
UOS	UOS	SHA-256	t	DPoI	\N	1000000000
BDX	Beldex	CryptoNight	t	PoW	980222595	1400222610
ZEN	Horizen	Equihash	t	PoW	7296537.5	21000000
XBC	BitcoinPlus	Scrypt	t	PoS	128326.9963	1000000
DVTC	DivotyCoin	Scrypt	f	PoW/PoS	21491213.46	100000000
GIOT	Giotto Coin	Scrypt	f	PoW/PoS	\N	233100000
OPSC	OpenSourceCoin	SHA-256	f	PoW/PoS	\N	21000000
PUNK	SteamPunk	PoS	f	PoS	\N	40000000
\.


--
-- Data for Name: bookmarks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookmarks ("userID", created_at, "coinUUID") FROM stdin;
474a5778-954a-4a66-adbd-d9ba877b3016	2023-04-18 16:51:18.235624+00	Qwsogvtv82FCd
\.


--
-- Data for Name: buyTransaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."buyTransaction" (id, created_at, "userID", "coinUUID", "coinPrice") FROM stdin;
\.


--
-- Data for Name: portfolio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.portfolio (id, "userID", created_at, "coinUUID", "buyID") FROM stdin;
\.


--
-- Data for Name: sellTransaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."sellTransaction" (id, created_at, "buyID", "userID", "coinUUID", "coinPrice") FROM stdin;
\.


--
-- Data for Name: userData; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."userData" ("userID", created_at, balance) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2023-03-22 09:36:32.233621
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2023-03-22 09:36:32.237145
2	pathtoken-column	49756be03be4c17bb85fe70d4a861f27de7e49ad	2023-03-22 09:36:32.239064
3	add-migrations-rls	bb5d124c53d68635a883e399426c6a5a25fc893d	2023-03-22 09:36:32.266206
4	add-size-functions	6d79007d04f5acd288c9c250c42d2d5fd286c54d	2023-03-22 09:36:32.273449
5	change-column-name-in-get-size	fd65688505d2ffa9fbdc58a944348dd8604d688c	2023-03-22 09:36:32.2788
6	add-rls-to-buckets	63e2bab75a2040fee8e3fb3f15a0d26f3380e9b6	2023-03-22 09:36:32.284229
7	add-public-to-buckets	82568934f8a4d9e0a85f126f6fb483ad8214c418	2023-03-22 09:36:32.287458
8	fix-search-function	1a43a40eddb525f2e2f26efd709e6c06e58e059c	2023-03-22 09:36:32.291409
9	search-files-search-function	34c096597eb8b9d077fdfdde9878c88501b2fafc	2023-03-22 09:36:32.294899
10	add-trigger-to-auto-update-updated_at-column	37d6bb964a70a822e6d37f22f457b9bca7885928	2023-03-22 09:36:32.300113
11	add-automatic-avif-detection-flag	bd76c53a9c564c80d98d119c1b3a28e16c8152db	2023-03-22 09:36:32.303589
12	add-bucket-custom-limits	cbe0a4c32a0e891554a21020433b7a4423c07ee7	2023-03-22 09:36:32.306371
13	use-bytes-for-max-size	7a158ebce8a0c2801c9c65b7e9b2f98f68b3874e	2023-03-22 09:36:32.310166
14	add-can-insert-object-function	273193826bca7e0990b458d1ba72f8aa27c0d825	2023-03-22 09:36:32.325819
15	add-version	e821a779d26612899b8c2dfe20245f904a327c4f	2023-04-07 13:05:15.802558
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 93, true);


--
-- Name: key_key_id_seq; Type: SEQUENCE SET; Schema: pgsodium; Owner: supabase_admin
--

SELECT pg_catalog.setval('pgsodium.key_key_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (provider, id);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: next_auth; Owner: postgres
--

ALTER TABLE ONLY next_auth.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: users email_unique; Type: CONSTRAINT; Schema: next_auth; Owner: postgres
--

ALTER TABLE ONLY next_auth.users
    ADD CONSTRAINT email_unique UNIQUE (email);


--
-- Name: accounts provider_unique; Type: CONSTRAINT; Schema: next_auth; Owner: postgres
--

ALTER TABLE ONLY next_auth.accounts
    ADD CONSTRAINT provider_unique UNIQUE (provider, "providerAccountId");


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: next_auth; Owner: postgres
--

ALTER TABLE ONLY next_auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sessions sessiontoken_unique; Type: CONSTRAINT; Schema: next_auth; Owner: postgres
--

ALTER TABLE ONLY next_auth.sessions
    ADD CONSTRAINT sessiontoken_unique UNIQUE ("sessionToken");


--
-- Name: verification_tokens token_identifier_unique; Type: CONSTRAINT; Schema: next_auth; Owner: postgres
--

ALTER TABLE ONLY next_auth.verification_tokens
    ADD CONSTRAINT token_identifier_unique UNIQUE (token, identifier);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: next_auth; Owner: postgres
--

ALTER TABLE ONLY next_auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: verification_tokens verification_tokens_pkey; Type: CONSTRAINT; Schema: next_auth; Owner: postgres
--

ALTER TABLE ONLY next_auth.verification_tokens
    ADD CONSTRAINT verification_tokens_pkey PRIMARY KEY (token);


--
-- Name: Coins Coins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Coins"
    ADD CONSTRAINT "Coins_pkey" PRIMARY KEY ("Symbol");


--
-- Name: bookmarks bookmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT bookmarks_pkey PRIMARY KEY ("userID", "coinUUID");


--
-- Name: buyTransaction buyTransaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."buyTransaction"
    ADD CONSTRAINT "buyTransaction_pkey" PRIMARY KEY (id);


--
-- Name: portfolio portfolio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portfolio
    ADD CONSTRAINT portfolio_pkey PRIMARY KEY (id, "userID", "buyID");


--
-- Name: sellTransaction sellTransaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."sellTransaction"
    ADD CONSTRAINT "sellTransaction_pkey" PRIMARY KEY (id, "buyID");


--
-- Name: userData userData_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userData"
    ADD CONSTRAINT "userData_pkey" PRIMARY KEY ("userID");


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_token_idx ON auth.refresh_tokens USING btree (token);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: accounts accounts_userId_fkey; Type: FK CONSTRAINT; Schema: next_auth; Owner: postgres
--

ALTER TABLE ONLY next_auth.accounts
    ADD CONSTRAINT "accounts_userId_fkey" FOREIGN KEY ("userId") REFERENCES next_auth.users(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_userId_fkey; Type: FK CONSTRAINT; Schema: next_auth; Owner: postgres
--

ALTER TABLE ONLY next_auth.sessions
    ADD CONSTRAINT "sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES next_auth.users(id) ON DELETE CASCADE;


--
-- Name: bookmarks bookmarks_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT "bookmarks_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: buyTransaction buyTransaction_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."buyTransaction"
    ADD CONSTRAINT "buyTransaction_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: portfolio portfolio_buyID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portfolio
    ADD CONSTRAINT "portfolio_buyID_fkey" FOREIGN KEY ("buyID") REFERENCES public."buyTransaction"(id) ON DELETE CASCADE;


--
-- Name: portfolio portfolio_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portfolio
    ADD CONSTRAINT "portfolio_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sellTransaction sellTransaction_buyID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."sellTransaction"
    ADD CONSTRAINT "sellTransaction_buyID_fkey" FOREIGN KEY ("buyID") REFERENCES public."buyTransaction"(id);


--
-- Name: sellTransaction sellTransaction_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."sellTransaction"
    ADD CONSTRAINT "sellTransaction_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: userData userData_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userData"
    ADD CONSTRAINT "userData_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: buckets buckets_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: objects objects_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: Coins; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."Coins" ENABLE ROW LEVEL SECURITY;

--
-- Name: buyTransaction Enable all actions for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable all actions for users based on user_id" ON public."buyTransaction" USING ((auth.uid() = "userID")) WITH CHECK ((auth.uid() = "userID"));


--
-- Name: bookmarks Enable all for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable all for users based on user_id" ON public.bookmarks USING ((auth.uid() = "userID")) WITH CHECK ((auth.uid() = "userID"));


--
-- Name: sellTransaction Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable delete for users based on user_id" ON public."sellTransaction" USING ((auth.uid() = "userID")) WITH CHECK ((auth.uid() = "userID"));


--
-- Name: Coins Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public."Coins" FOR SELECT USING (true);


--
-- Name: bookmarks; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;

--
-- Name: buyTransaction; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."buyTransaction" ENABLE ROW LEVEL SECURITY;

--
-- Name: portfolio; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.portfolio ENABLE ROW LEVEL SECURITY;

--
-- Name: sellTransaction; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."sellTransaction" ENABLE ROW LEVEL SECURITY;

--
-- Name: userData; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."userData" ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA graphql_public; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA graphql_public TO postgres;
GRANT USAGE ON SCHEMA graphql_public TO anon;
GRANT USAGE ON SCHEMA graphql_public TO authenticated;
GRANT USAGE ON SCHEMA graphql_public TO service_role;


--
-- Name: SCHEMA next_auth; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA next_auth TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;
GRANT ALL ON FUNCTION auth.email() TO postgres;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;
GRANT ALL ON FUNCTION auth.role() TO postgres;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;
GRANT ALL ON FUNCTION auth.uid() TO postgres;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM postgres;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION comment_directive(comment_ text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO postgres;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO anon;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO authenticated;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO service_role;


--
-- Name: FUNCTION exception(message text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.exception(message text) TO postgres;
GRANT ALL ON FUNCTION graphql.exception(message text) TO anon;
GRANT ALL ON FUNCTION graphql.exception(message text) TO authenticated;
GRANT ALL ON FUNCTION graphql.exception(message text) TO service_role;


--
-- Name: FUNCTION get_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.get_schema_version() TO postgres;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO anon;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO authenticated;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO service_role;


--
-- Name: FUNCTION increment_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.increment_schema_version() TO postgres;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO anon;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO authenticated;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO service_role;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_keygen(); Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO service_role;


--
-- Name: FUNCTION can_insert_object(bucketid text, name text, owner uuid, metadata jsonb); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) TO postgres;


--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO anon;
GRANT ALL ON FUNCTION storage.extension(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.extension(name text) TO service_role;
GRANT ALL ON FUNCTION storage.extension(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO anon;
GRANT ALL ON FUNCTION storage.filename(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.filename(name text) TO service_role;
GRANT ALL ON FUNCTION storage.filename(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO anon;
GRANT ALL ON FUNCTION storage.foldername(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.foldername(name text) TO service_role;
GRANT ALL ON FUNCTION storage.foldername(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- Name: FUNCTION get_size_by_bucket(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.get_size_by_bucket() TO postgres;


--
-- Name: FUNCTION search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) TO postgres;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.update_updated_at_column() TO postgres;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT ALL ON TABLE auth.audit_log_entries TO postgres;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.flow_state TO postgres;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.identities TO postgres;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT ALL ON TABLE auth.instances TO postgres;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_amr_claims TO postgres;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_challenges TO postgres;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_factors TO postgres;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT ALL ON TABLE auth.refresh_tokens TO postgres;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_providers TO postgres;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_relay_states TO postgres;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;
GRANT ALL ON TABLE auth.schema_migrations TO postgres;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sessions TO postgres;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_domains TO postgres;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_providers TO postgres;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT ALL ON TABLE auth.users TO postgres;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: SEQUENCE seq_schema_version; Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE graphql.seq_schema_version TO postgres;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO anon;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO authenticated;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO service_role;


--
-- Name: TABLE accounts; Type: ACL; Schema: next_auth; Owner: postgres
--

GRANT ALL ON TABLE next_auth.accounts TO service_role;


--
-- Name: TABLE sessions; Type: ACL; Schema: next_auth; Owner: postgres
--

GRANT ALL ON TABLE next_auth.sessions TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: next_auth; Owner: postgres
--

GRANT ALL ON TABLE next_auth.users TO service_role;


--
-- Name: TABLE verification_tokens; Type: ACL; Schema: next_auth; Owner: postgres
--

GRANT ALL ON TABLE next_auth.verification_tokens TO service_role;


--
-- Name: TABLE decrypted_key; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.decrypted_key TO pgsodium_keyholder;


--
-- Name: TABLE masking_rule; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.masking_rule TO pgsodium_keyholder;


--
-- Name: TABLE mask_columns; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.mask_columns TO pgsodium_keyholder;


--
-- Name: TABLE "Coins"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."Coins" TO anon;
GRANT ALL ON TABLE public."Coins" TO authenticated;
GRANT ALL ON TABLE public."Coins" TO service_role;


--
-- Name: TABLE bookmarks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.bookmarks TO anon;
GRANT ALL ON TABLE public.bookmarks TO authenticated;
GRANT ALL ON TABLE public.bookmarks TO service_role;


--
-- Name: TABLE "buyTransaction"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."buyTransaction" TO anon;
GRANT ALL ON TABLE public."buyTransaction" TO authenticated;
GRANT ALL ON TABLE public."buyTransaction" TO service_role;


--
-- Name: TABLE portfolio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.portfolio TO anon;
GRANT ALL ON TABLE public.portfolio TO authenticated;
GRANT ALL ON TABLE public.portfolio TO service_role;


--
-- Name: TABLE "sellTransaction"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."sellTransaction" TO anon;
GRANT ALL ON TABLE public."sellTransaction" TO authenticated;
GRANT ALL ON TABLE public."sellTransaction" TO service_role;


--
-- Name: TABLE "userData"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."userData" TO anon;
GRANT ALL ON TABLE public."userData" TO authenticated;
GRANT ALL ON TABLE public."userData" TO service_role;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES  TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON SEQUENCES  TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON TABLES  TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON SEQUENCES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON FUNCTIONS  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON TABLES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE SCHEMA')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

