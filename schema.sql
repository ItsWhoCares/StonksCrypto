--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg20.04+1)
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
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: addToPortfolio(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."addToPortfolio"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  INSERT INTO portfolio("userID", "buyID", "coinUUID", quantity, "coinPrice") VALUES (new."userID", new.id, new."coinUUID", new.quantity, new."coinPrice");
  return new;
END;$$;


ALTER FUNCTION public."addToPortfolio"() OWNER TO postgres;

--
-- Name: canAfford(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."canAfford"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  IF new."coinPrice" * new.quantity > (SELECT balance FROM user_data WHERE user_id = new."userID")
  THEN
    RAISE EXCEPTION 'Insufficient balance';
  END IF;
  RETURN NEW;
END;$$;


ALTER FUNCTION public."canAfford"() OWNER TO postgres;

--
-- Name: removeFromPortfolio(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."removeFromPortfolio"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  DELETE FROM portfolio
    WHERE "buyID" = new."buyID" and "userID" = new."userID";
  return new;
end;$$;


ALTER FUNCTION public."removeFromPortfolio"() OWNER TO postgres;

--
-- Name: setDefaultBalance(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."setDefaultBalance"() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
  insert into public.user_data (user_id, balance)
  values (new.id, 10000.0);
  return new;
end;
$$;


ALTER FUNCTION public."setDefaultBalance"() OWNER TO postgres;

--
-- Name: ss(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ss() RETURNS trigger
    LANGUAGE plpgsql
    AS $$begin
  select 2+2;
  return new;
end;$$;


ALTER FUNCTION public.ss() OWNER TO postgres;

--
-- Name: updateBalanceBuy(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."updateBalanceBuy"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  UPDATE user_data
    SET balance = balance - (new."coinPrice" * new.quantity)
      WHERE user_id = new."userID";
  RETURN NEW;
END;
$$;


ALTER FUNCTION public."updateBalanceBuy"() OWNER TO postgres;

--
-- Name: updateBalanceSell(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."updateBalanceSell"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  UPDATE user_data
    SET balance = balance + (new."coinPrice" * new.quantity)
      WHERE user_id = new."userID";
  RETURN new;
END;$$;


ALTER FUNCTION public."updateBalanceSell"() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

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
-- Name: buy_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.buy_transaction (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "userID" uuid NOT NULL,
    "coinUUID" text NOT NULL,
    "coinPrice" double precision NOT NULL,
    quantity bigint NOT NULL
);


ALTER TABLE public.buy_transaction OWNER TO postgres;

--
-- Name: portfolio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.portfolio (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    "userID" uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "coinUUID" text NOT NULL,
    "buyID" uuid NOT NULL,
    quantity bigint NOT NULL,
    "coinPrice" double precision
);


ALTER TABLE public.portfolio OWNER TO postgres;

--
-- Name: sell_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sell_transaction (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    "buyID" uuid NOT NULL,
    "userID" uuid NOT NULL,
    "coinUUID" text NOT NULL,
    "coinPrice" double precision NOT NULL,
    quantity bigint NOT NULL
);


ALTER TABLE public.sell_transaction OWNER TO postgres;

--
-- Name: user_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_data (
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    balance double precision
);


ALTER TABLE public.user_data OWNER TO postgres;

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
-- Name: buy_transaction buyTransaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buy_transaction
    ADD CONSTRAINT "buyTransaction_pkey" PRIMARY KEY (id);


--
-- Name: portfolio portfolio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portfolio
    ADD CONSTRAINT portfolio_pkey PRIMARY KEY (id, "userID", "buyID");


--
-- Name: sell_transaction sellTransaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sell_transaction
    ADD CONSTRAINT "sellTransaction_pkey" PRIMARY KEY (id, "buyID");


--
-- Name: user_data user_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_data
    ADD CONSTRAINT user_data_pkey PRIMARY KEY (user_id);


--
-- Name: buy_transaction afterBuyAddToPortfolio; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "afterBuyAddToPortfolio" AFTER INSERT ON public.buy_transaction FOR EACH ROW EXECUTE FUNCTION public."addToPortfolio"();


--
-- Name: buy_transaction afterBuyUpdateBalance; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "afterBuyUpdateBalance" AFTER INSERT ON public.buy_transaction FOR EACH ROW EXECUTE FUNCTION public."updateBalanceBuy"();


--
-- Name: sell_transaction afterSellRemoveFromPortfolio; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "afterSellRemoveFromPortfolio" AFTER INSERT ON public.sell_transaction FOR EACH ROW EXECUTE FUNCTION public."removeFromPortfolio"();


--
-- Name: sell_transaction afterSellUpdateBalance; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "afterSellUpdateBalance" AFTER INSERT ON public.sell_transaction FOR EACH ROW EXECUTE FUNCTION public."updateBalanceSell"();


--
-- Name: buy_transaction checkBeforeBuy; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "checkBeforeBuy" BEFORE INSERT ON public.buy_transaction FOR EACH ROW EXECUTE FUNCTION public."canAfford"();


--
-- Name: bookmarks bookmarks_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT "bookmarks_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: buy_transaction buy_transaction_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.buy_transaction
    ADD CONSTRAINT "buy_transaction_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: portfolio portfolio_buyID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portfolio
    ADD CONSTRAINT "portfolio_buyID_fkey" FOREIGN KEY ("buyID") REFERENCES public.buy_transaction(id) ON DELETE CASCADE;


--
-- Name: portfolio portfolio_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.portfolio
    ADD CONSTRAINT "portfolio_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sell_transaction sell_transaction_buyID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sell_transaction
    ADD CONSTRAINT "sell_transaction_buyID_fkey" FOREIGN KEY ("buyID") REFERENCES public.buy_transaction(id);


--
-- Name: sell_transaction sell_transaction_userID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sell_transaction
    ADD CONSTRAINT "sell_transaction_userID_fkey" FOREIGN KEY ("userID") REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: user_data user_data_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_data
    ADD CONSTRAINT user_data_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: Coins; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public."Coins" ENABLE ROW LEVEL SECURITY;

--
-- Name: buy_transaction Enable all actions for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable all actions for users based on user_id" ON public.buy_transaction USING ((auth.uid() = "userID")) WITH CHECK ((auth.uid() = "userID"));


--
-- Name: bookmarks Enable all for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable all for users based on user_id" ON public.bookmarks USING ((auth.uid() = "userID")) WITH CHECK ((auth.uid() = "userID"));


--
-- Name: portfolio Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable delete for users based on user_id" ON public.portfolio USING ((auth.uid() = "userID")) WITH CHECK ((auth.uid() = "userID"));


--
-- Name: sell_transaction Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable delete for users based on user_id" ON public.sell_transaction USING ((auth.uid() = "userID")) WITH CHECK ((auth.uid() = "userID"));


--
-- Name: Coins Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public."Coins" FOR SELECT USING (true);


--
-- Name: user_data Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.user_data USING (true) WITH CHECK (true);


--
-- Name: bookmarks; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;

--
-- Name: buy_transaction; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.buy_transaction ENABLE ROW LEVEL SECURITY;

--
-- Name: portfolio; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.portfolio ENABLE ROW LEVEL SECURITY;

--
-- Name: sell_transaction; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sell_transaction ENABLE ROW LEVEL SECURITY;

--
-- Name: user_data; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_data ENABLE ROW LEVEL SECURITY;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: FUNCTION "addToPortfolio"(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public."addToPortfolio"() TO anon;
GRANT ALL ON FUNCTION public."addToPortfolio"() TO authenticated;
GRANT ALL ON FUNCTION public."addToPortfolio"() TO service_role;


--
-- Name: FUNCTION "canAfford"(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public."canAfford"() TO anon;
GRANT ALL ON FUNCTION public."canAfford"() TO authenticated;
GRANT ALL ON FUNCTION public."canAfford"() TO service_role;


--
-- Name: FUNCTION "removeFromPortfolio"(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public."removeFromPortfolio"() TO anon;
GRANT ALL ON FUNCTION public."removeFromPortfolio"() TO authenticated;
GRANT ALL ON FUNCTION public."removeFromPortfolio"() TO service_role;


--
-- Name: FUNCTION "setDefaultBalance"(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public."setDefaultBalance"() TO anon;
GRANT ALL ON FUNCTION public."setDefaultBalance"() TO authenticated;
GRANT ALL ON FUNCTION public."setDefaultBalance"() TO service_role;


--
-- Name: FUNCTION ss(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.ss() TO anon;
GRANT ALL ON FUNCTION public.ss() TO authenticated;
GRANT ALL ON FUNCTION public.ss() TO service_role;


--
-- Name: FUNCTION "updateBalanceBuy"(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public."updateBalanceBuy"() TO anon;
GRANT ALL ON FUNCTION public."updateBalanceBuy"() TO authenticated;
GRANT ALL ON FUNCTION public."updateBalanceBuy"() TO service_role;


--
-- Name: FUNCTION "updateBalanceSell"(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public."updateBalanceSell"() TO anon;
GRANT ALL ON FUNCTION public."updateBalanceSell"() TO authenticated;
GRANT ALL ON FUNCTION public."updateBalanceSell"() TO service_role;


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
-- Name: TABLE buy_transaction; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.buy_transaction TO anon;
GRANT ALL ON TABLE public.buy_transaction TO authenticated;
GRANT ALL ON TABLE public.buy_transaction TO service_role;


--
-- Name: TABLE portfolio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.portfolio TO anon;
GRANT ALL ON TABLE public.portfolio TO authenticated;
GRANT ALL ON TABLE public.portfolio TO service_role;


--
-- Name: TABLE sell_transaction; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sell_transaction TO anon;
GRANT ALL ON TABLE public.sell_transaction TO authenticated;
GRANT ALL ON TABLE public.sell_transaction TO service_role;


--
-- Name: TABLE user_data; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_data TO anon;
GRANT ALL ON TABLE public.user_data TO authenticated;
GRANT ALL ON TABLE public.user_data TO service_role;


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
-- PostgreSQL database dump complete
--

