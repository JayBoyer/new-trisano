

--
-- TOC entry 329 (class 1255 OID 26909)
-- Dependencies: 6 703
-- Name: gtrgm_in(cstring); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gtrgm_in(cstring) RETURNS gtrgm
    LANGUAGE c STRICT
    AS '$libdir/pg_trgm', 'gtrgm_in';


ALTER FUNCTION public.gtrgm_in(cstring) OWNER TO trisano_user;

--
-- TOC entry 338 (class 1255 OID 26910)
-- Dependencies: 6 703
-- Name: gtrgm_out(gtrgm); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gtrgm_out(gtrgm) RETURNS cstring
    LANGUAGE c STRICT
    AS '$libdir/pg_trgm', 'gtrgm_out';


ALTER FUNCTION public.gtrgm_out(gtrgm) OWNER TO trisano_user;

--
-- TOC entry 702 (class 1247 OID 26908)
-- Dependencies: 6 329 338
-- Name: gtrgm; Type: TYPE; Schema: public; Owner: trisano_user
--


ALTER TYPE public.gtrgm OWNER TO trisano_user;

--
-- TOC entry 386 (class 1255 OID 35388)
-- Dependencies: 6 1081
-- Name: add_answer_to_flat(); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION add_answer_to_flat() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$

    DECLARE

       flat_table_name VARCHAR := null;
       flat_column_name VARCHAR := null;
       flat_value VARCHAR := null;
       found_event_id INTEGER := 0;
       found_outbreak_id INTEGER := 0;

    BEGIN

        IF NEW.code IS NOT NULL AND char_length(trim(NEW.code)) > 0
        THEN
            flat_value := NEW.code;
        END IF;

        IF flat_value IS NULL AND NEW.text_answer IS NOT NULL AND char_length(trim(NEW.text_answer)) > 0
        THEN
            flat_value := NEW.text_answer;
        END IF;

        IF flat_value IS NOT NULL THEN

            SELECT f.short_name FROM forms f 
            WHERE f.id = (
                SELECT form_id FROM form_elements fe 
                WHERE fe.id = (
                    SELECT form_element_id FROM questions 
                    WHERE id = NEW.question_id)) 
            INTO flat_table_name;

            SELECT q.short_name FROM questions q 
            WHERE q.id = NEW.question_id
            INTO flat_column_name;

            IF flat_column_name IS NOT NULL AND flat_table_name IS NOT NULL THEN

                flat_table_name := 'formbuilder_' || lower(flat_table_name) || '_1';
                flat_table_name := replace(flat_table_name, '#', '');
                flat_table_name := replace(flat_table_name, '.', '_');
                flat_table_name := replace(flat_table_name, ' ', '');
                flat_table_name := replace(flat_table_name, ',', '_');
                flat_table_name := replace(flat_table_name, '(', '');
                flat_table_name := replace(flat_table_name, ')', '');
                flat_table_name := replace(flat_table_name, ':', '');
                flat_table_name := replace(flat_table_name, '>', '_');
                flat_table_name := replace(flat_table_name, '<', '_');
                flat_table_name := replace(flat_table_name, '?', '');

                flat_column_name := 'col_' || lower(flat_column_name);
                flat_column_name := replace(flat_column_name, '#', '');
                flat_column_name := replace(flat_column_name, '.', '_');
                flat_column_name := replace(flat_column_name, ' ', '');
                flat_column_name := replace(flat_column_name, ',', '_');
                flat_column_name := replace(flat_column_name, '(', '');
                flat_column_name := replace(flat_column_name, ')', '');
                flat_column_name := replace(flat_column_name, ':', '');
                flat_column_name := replace(flat_column_name, '>', '_');
                flat_column_name := replace(flat_column_name, '<', '_');
                flat_column_name := replace(flat_column_name, '?', '');

                IF NEW.event_id IS NOT NULL AND NEW.event_id > 0 THEN
                    -- table and column exist. check for event record and update
                    EXECUTE 'SELECT event_id FROM ' || flat_table_name || ' WHERE event_id = $1'  
                    INTO found_event_id
                    USING NEW.event_id;

                    IF found_event_id IS NULL
                    THEN 
                        EXECUTE 'INSERT INTO ' || flat_table_name || '(event_id) VALUES ($1)'
                        USING NEW.event_id;
                    END IF;

                    EXECUTE 'UPDATE ' || flat_table_name || ' SET ' || flat_column_name || ' = $1 WHERE event_id = $2'
                    USING flat_value,NEW.event_id;
                
                ELSIF NEW.outbreak_id IS NOT NULL AND NEW.outbreak_id > 0 THEN
                    
                    EXECUTE 'SELECT outbreak_id FROM ' || flat_table_name || ' WHERE outbreak_id = $1'  
                    INTO found_outbreak_id
                    USING NEW.outbreak_id;

                    IF found_outbreak_id IS NULL
                    THEN 
                        EXECUTE 'INSERT INTO ' || flat_table_name || '(outbreak_id) VALUES ($1)'
                        USING NEW.outbreak_id;
                    END IF;

                    EXECUTE 'UPDATE ' || flat_table_name || ' SET ' || flat_column_name || ' = $1 WHERE outbreak_id = $2'
                    USING flat_value,NEW.outbreak_id;
                
                END IF;
            
            END IF;
        END IF;

        RETURN NEW;
    END;
$_$;


ALTER FUNCTION public.add_answer_to_flat() OWNER TO trisano_su;

--
-- TOC entry 379 (class 1255 OID 35381)
-- Dependencies: 1081 6
-- Name: add_column_to_flat(); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION add_column_to_flat() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    DECLARE

       flat_table_name VARCHAR := null;
       flat_column_name VARCHAR := NEW.short_name;
    
    BEGIN

        SELECT f.short_name FROM forms f 
        WHERE f.id = (
            SELECT form_id FROM form_elements fe 
            WHERE fe.id = NEW.form_element_id) 
        INTO flat_table_name;

        IF flat_column_name IS NOT NULL AND flat_table_name IS NOT NULL THEN

            flat_table_name := 'formbuilder_' || lower(flat_table_name) || '_1';
            flat_table_name := replace(flat_table_name, '#', '');
            flat_table_name := replace(flat_table_name, '.', '_');
            flat_table_name := replace(flat_table_name, ' ', '');
            flat_table_name := replace(flat_table_name, ',', '_');
            flat_table_name := replace(flat_table_name, '(', '');
            flat_table_name := replace(flat_table_name, ')', '');
            flat_table_name := replace(flat_table_name, ':', '');
            flat_table_name := replace(flat_table_name, '>', '_');
            flat_table_name := replace(flat_table_name, '<', '_');
            flat_table_name := replace(flat_table_name, '?', '');


            flat_column_name := 'col_' || lower(flat_column_name);
            flat_column_name := replace(flat_column_name, '#', '');
            flat_column_name := replace(flat_column_name, '.', '_');
            flat_column_name := replace(flat_column_name, ' ', '');
            flat_column_name := replace(flat_column_name, ',', '_');
            flat_column_name := replace(flat_column_name, '(', '');
            flat_column_name := replace(flat_column_name, ')', '');
            flat_column_name := replace(flat_column_name, ':', '');
            flat_column_name := replace(flat_column_name, '>', '_');
            flat_column_name := replace(flat_column_name, '<', '_');
            flat_column_name := replace(flat_column_name, '?', '');

            BEGIN
               EXECUTE '
               ALTER TABLE ' || flat_table_name || ' ADD COLUMN ' || flat_column_name || ' text';
            EXCEPTION WHEN OTHERS THEN
                -- do nothing
            END;

        END IF;

            RETURN NEW;
        END;
$$;


ALTER FUNCTION public.add_column_to_flat() OWNER TO trisano_su;

--
-- TOC entry 360 (class 1255 OID 35377)
-- Dependencies: 1081 6
-- Name: add_table_to_flat(); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION add_table_to_flat() RETURNS trigger
    LANGUAGE plpgsql
    AS $$



    DECLARE

        flat_table_name VARCHAR := null;

    BEGIN

        IF NEW.short_name IS NOT NULL THEN

            flat_table_name := 'formbuilder_' || lower(NEW.short_name) || '_1';
            flat_table_name := replace(flat_table_name, '#', '');
            flat_table_name := replace(flat_table_name, '.', '_');
            flat_table_name := replace(flat_table_name, ' ', '');
            flat_table_name := replace(flat_table_name, ',', '_');
            flat_table_name := replace(flat_table_name, '(', '');
            flat_table_name := replace(flat_table_name, ')', '');
            flat_table_name := replace(flat_table_name, ':', '');
            flat_table_name := replace(flat_table_name, '>', '_');
            flat_table_name := replace(flat_table_name, '<', '_');

            BEGIN
                EXECUTE 'CREATE TABLE ' || flat_table_name || '(event_id INTEGER, outbreak_id INTEGER)';
            EXCEPTION WHEN OTHERS THEN
                -- do nothing
            END;

        END IF;
    
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.add_table_to_flat() OWNER TO trisano_su;

--
-- TOC entry 362 (class 1255 OID 35379)
-- Dependencies: 6 1081
-- Name: apply_mmwr(); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION apply_mmwr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        -- If the disease onset date first, collection date, date reported then date created
        IF NEW.event_onset_date IS NOT NULL THEN
            
            NEW.MMWR_week := mmwr_week(NEW.event_onset_date);
            NEW.MMWR_year := mmwr_year(NEW.event_onset_date);

        END IF;

        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.apply_mmwr() OWNER TO trisano_su;

--
-- TOC entry 339 (class 1255 OID 26912)
-- Dependencies: 6
-- Name: difference(text, text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION difference(text, text) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/fuzzystrmatch', 'difference';


ALTER FUNCTION public.difference(text, text) OWNER TO trisano_user;

--
-- TOC entry 382 (class 1255 OID 35384)
-- Dependencies: 6 1081
-- Name: disease_events_event_onset_date(); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION disease_events_event_onset_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        UPDATE events set event_onset_date = get_event_onset_date(NEW.event_id);
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.disease_events_event_onset_date() OWNER TO trisano_su;

--
-- TOC entry 340 (class 1255 OID 26913)
-- Dependencies: 6
-- Name: dmetaphone(text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION dmetaphone(text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/fuzzystrmatch', 'dmetaphone';


ALTER FUNCTION public.dmetaphone(text) OWNER TO trisano_user;

--
-- TOC entry 345 (class 1255 OID 26914)
-- Dependencies: 6
-- Name: dmetaphone_alt(text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION dmetaphone_alt(text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/fuzzystrmatch', 'dmetaphone_alt';


ALTER FUNCTION public.dmetaphone_alt(text) OWNER TO trisano_user;

--
-- TOC entry 381 (class 1255 OID 35383)
-- Dependencies: 6 1081
-- Name: events_event_onset_date(); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION events_event_onset_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        UPDATE events set event_onset_date = get_event_onset_date(NEW.id);
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.events_event_onset_date() OWNER TO trisano_su;

--
-- TOC entry 376 (class 1255 OID 35372)
-- Dependencies: 6 1081
-- Name: fntrisanoexport(integer); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION fntrisanoexport(integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
declare 
	iexport_id  ALIAS  FOR $1;
	vexport_name varchar(50);
	return_status varchar(50);
BEGIN
-- If the passed in value is NULL, then error!
	IF iexport_id IS NULL  
	THEN RETURN 'NULL VALUE PASSED';
	END IF;
-- If the passed in value is NOT NULL, but is not found in the export_names table, then error!
	SELECT export_name INTO vexport_name FROM export_names WHERE id = iexport_id;
	if vexport_name is NULL
	THEN RETURN 'Invalid export_name.id';
	END IF;

-- Get all the columns for the export_name that will need to be retrieved from the database.
	IF (vexport_name = 'CDC')
	THEN

	   return_status = fnTrisanoExportNonGenericCdc(iexport_id, vexport_name);
--	   return_status = fnTrisanoExportCdc(iexport_id, vexport_name);
	   return return_status;
--	   IF substring(return_status,1,7) = 'SUCCESS'
--	   THEN
--		return 'SUCCESS';
--	   ELSE
--		return 'FAILURE';
--	   END IF;
	ELSE
		return vexport_name;
	END IF;

END;
$_$;


ALTER FUNCTION public.fntrisanoexport(integer) OWNER TO trisano_su;

--
-- TOC entry 391 (class 1255 OID 35395)
-- Dependencies: 6 1081
-- Name: get_age_at_onset(integer, date); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION get_age_at_onset(event_id_in integer, event_onset_date_in date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    
    DECLARE
        
       age_and_type VARCHAR := null;
       birth_date_found DATE := null;
       age_at_onset INTEGER := null;
       age INTEGER := null;
       age_type_id INTEGER := null;
     
    BEGIN

       SELECT birth_date FROM people WHERE entity_id = 
        (SELECT primary_entity_id FROM participations WHERE event_id = event_id_in LIMIT 1) 
       INTO birth_date_found;

       IF birth_date_found IS NOT NULL AND event_onset_date_in IS NOT NULL THEN 

            -- calculate age_at_onset
            SELECT date_part('year',age(event_onset_date_in, birth_date_found)) INTO age;
            IF age = 0 THEN
                SELECT date_part('mons',age(event_onset_date_in, birth_date_found)) INTO age;
                IF age = 0 THEN
                    select id from public.external_codes where code_name = 'age_type' and code_description = 'years' into age_type_id;        age_and_type := '0,0';
                    age_and_type := '0,' || age_type_id;
                ELSE
                    select id from public.external_codes where code_name = 'age_type' and code_description = 'months' into age_type_id;
                    age_and_type := age || ',' || age_type_id;
                END IF;
            ELSE
                select id from public.external_codes where code_name = 'age_type' and code_description = 'years' into age_type_id;
                age_and_type := age || ',' || age_type_id;
            END IF;
       END IF;

    RETURN age_and_type;
       
    END;
  
$$;


ALTER FUNCTION public.get_age_at_onset(event_id_in integer, event_onset_date_in date) OWNER TO trisano_su;

--
-- TOC entry 390 (class 1255 OID 35394)
-- Dependencies: 1081 6
-- Name: get_age_onset(integer); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION get_age_onset(event_id_in integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    
    DECLARE
        
       age_and_type VARCHAR := null;
       birth_date_found DATE := null;
       event_onset_found DATE := null;
       age_at_onset INTEGER := null;
       age FLOAT := null;
       age_type_id INTEGER := null;
     
    BEGIN

       SELECT event_onset_date FROM events WHERE id=event_id_in LIMIT 1 
       INTO event_onset_found;

       SELECT birth_date FROM people WHERE entity_id = 
        (SELECT primary_entity_id FROM participations WHERE event_id = event_id_in LIMIT 1) 
       INTO birth_date_found;

       IF birth_date_found IS NOT NULL AND event_onset_found IS NOT NULL THEN 
            -- calculate age_at_onset
	select floor(extract(day from (event_onset_found::timestamp with time zone - birth_date_found::timestamp with time zone))/365) into age;
	IF age < 1 THEN
	select round((extract(day from (event_onset_found::timestamp with time zone - birth_date_found::timestamp with time zone))/365)::numeric,2) into age;
	END IF;
       END IF;

    RETURN age;
       
    END;
  
$$;


ALTER FUNCTION public.get_age_onset(event_id_in integer) OWNER TO trisano_su;

--
-- TOC entry 388 (class 1255 OID 35390)
-- Dependencies: 6 1081
-- Name: get_disease(integer); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION get_disease(id_in integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
    
    DECLARE

       code_value text := null;
       
    BEGIN


        SELECT disease_name from diseases WHERE id = id_in 
        INTO code_value;

    RETURN code_value;
       
    END;
  
$$;


ALTER FUNCTION public.get_disease(id_in integer) OWNER TO trisano_su;

--
-- TOC entry 383 (class 1255 OID 35385)
-- Dependencies: 1081 6
-- Name: get_event_onset_date(integer); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION get_event_onset_date(event_id_in integer) RETURNS date
    LANGUAGE plpgsql
    AS $$
    
    DECLARE

       event_onset_date DATE := null;
       
    BEGIN


        SELECT least(disease_onset_date, date_diagnosed) 
        FROM disease_events WHERE event_id = event_id_in 
        INTO event_onset_date;

        IF event_onset_date IS NULL THEN
            SELECT least(e.created_at::date, e.first_reported_PH_date, 
                (SELECT min(collection_date) AS min_lab FROM vw_lab_results 
                 WHERE event_id=event_id_in and test_result_id=273),
                (SELECT min(lab_test_date) AS min_lab FROM vw_lab_results 
                 WHERE event_id=event_id_in and test_result_id=273), d.disease_onset_date, d.date_diagnosed) 
            FROM events e 
            LEFT JOIN disease_events d ON d.event_id=e.id WHERE e.id=event_id_in
            INTO event_onset_date;
        END IF;

    RETURN event_onset_date;
       
    END;
  
$$;


ALTER FUNCTION public.get_event_onset_date(event_id_in integer) OWNER TO trisano_su;

--
-- TOC entry 384 (class 1255 OID 35386)
-- Dependencies: 6 1081
-- Name: get_externalcode(integer); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION get_externalcode(id_in integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
    
    DECLARE

       code_value text := null;
       
    BEGIN


        SELECT code_description from external_codes WHERE id = id_in 
        INTO code_value;

    RETURN code_value;
       
    END;
  
$$;


ALTER FUNCTION public.get_externalcode(id_in integer) OWNER TO trisano_su;

--
-- TOC entry 341 (class 1255 OID 26915)
-- Dependencies: 6
-- Name: get_full_name(character varying, character varying); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION get_full_name(character varying, character varying) RETURNS character varying
    LANGUAGE sql IMMUTABLE
    AS $_$
    SELECT COALESCE($1, ''::varchar) || ' '::varchar || COALESCE($2, ''::varchar)
$_$;


ALTER FUNCTION public.get_full_name(character varying, character varying) OWNER TO trisano_user;

--
-- TOC entry 392 (class 1255 OID 35396)
-- Dependencies: 1081 6
-- Name: get_j_inv(integer); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION get_j_inv(event_id_in integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    
    DECLARE
        
       jurisdiction_at_inv VARCHAR := null;
     
    BEGIN

       select name from places p inner join participations pa on pa.secondary_entity_id = p.entity_id where pa.type='Jurisdiction' and pa.event_id=event_id_in into jurisdiction_at_inv;

       IF jurisdiction_at_inv IS NOT NULL THEN 
	RETURN jurisdiction_at_inv;
	ELSE
	RETURN 'Unassigned';
       END IF;

       
    END;
  
$$;


ALTER FUNCTION public.get_j_inv(event_id_in integer) OWNER TO trisano_su;

--
-- TOC entry 380 (class 1255 OID 35382)
-- Dependencies: 6 1081
-- Name: get_j_res(integer); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION get_j_res(event_id_in integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    
    DECLARE
        
       jurisdiction_at_res VARCHAR := null;
     
    BEGIN

       select name from places p inner join external_codes ec on ec.jurisdiction_id = p.id inner join addresses a on a.county_id=ec.id where a.event_id=event_id_in into jurisdiction_at_res;

       IF jurisdiction_at_res IS NOT NULL THEN 
	RETURN jurisdiction_at_res;
	ELSE
	RETURN 'Unknown';
       END IF;

       
    END;
  
$$;


ALTER FUNCTION public.get_j_res(event_id_in integer) OWNER TO trisano_su;

--
-- TOC entry 389 (class 1255 OID 35391)
-- Dependencies: 6 1081
-- Name: get_place(integer); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION get_place(id_in integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
    
    DECLARE

       code_value text := null;
       
    BEGIN


        SELECT name from places WHERE entity_id = id_in 
        INTO code_value;

    RETURN code_value;
       
    END;
  
$$;


ALTER FUNCTION public.get_place(id_in integer) OWNER TO trisano_su;

--
-- TOC entry 342 (class 1255 OID 26916)
-- Dependencies: 6
-- Name: get_trigram_tsvector(text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION get_trigram_tsvector(text) RETURNS tsvector
    LANGUAGE sql IMMUTABLE
    AS $_$
    SELECT
    to_tsvector(
        'simple_no_stop'::regconfig,
        array_to_string(
            show_trgm(
                lower($1)
            ), ' '::text
        )
    )
$_$;


ALTER FUNCTION public.get_trigram_tsvector(text) OWNER TO trisano_user;

--
-- TOC entry 385 (class 1255 OID 35387)
-- Dependencies: 6 1081
-- Name: get_user(integer); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION get_user(id_in integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
    
    DECLARE

       user_name text := null;
       
    BEGIN


        SELECT first_name || ' ' || last_name from users WHERE id = id_in 
        INTO user_name;

    RETURN user_name;
       
    END;
  
$$;


ALTER FUNCTION public.get_user(id_in integer) OWNER TO trisano_su;

--
-- TOC entry 343 (class 1255 OID 26917)
-- Dependencies: 6
-- Name: gin_extract_trgm(text, internal); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gin_extract_trgm(text, internal) RETURNS internal
    LANGUAGE c IMMUTABLE
    AS '$libdir/pg_trgm', 'gin_extract_trgm';


ALTER FUNCTION public.gin_extract_trgm(text, internal) OWNER TO trisano_user;

--
-- TOC entry 344 (class 1255 OID 26918)
-- Dependencies: 6
-- Name: gin_extract_trgm(text, internal, internal); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gin_extract_trgm(text, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE
    AS '$libdir/pg_trgm', 'gin_extract_trgm';


ALTER FUNCTION public.gin_extract_trgm(text, internal, internal) OWNER TO trisano_user;

--
-- TOC entry 346 (class 1255 OID 26919)
-- Dependencies: 6
-- Name: gin_trgm_consistent(internal, internal, text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gin_trgm_consistent(internal, internal, text) RETURNS internal
    LANGUAGE c IMMUTABLE
    AS '$libdir/pg_trgm', 'gin_trgm_consistent';


ALTER FUNCTION public.gin_trgm_consistent(internal, internal, text) OWNER TO trisano_user;

--
-- TOC entry 347 (class 1255 OID 26920)
-- Dependencies: 6
-- Name: gtrgm_compress(internal); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gtrgm_compress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE
    AS '$libdir/pg_trgm', 'gtrgm_compress';


ALTER FUNCTION public.gtrgm_compress(internal) OWNER TO trisano_user;

--
-- TOC entry 348 (class 1255 OID 26921)
-- Dependencies: 6 702
-- Name: gtrgm_consistent(gtrgm, internal, integer); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gtrgm_consistent(gtrgm, internal, integer) RETURNS boolean
    LANGUAGE c IMMUTABLE
    AS '$libdir/pg_trgm', 'gtrgm_consistent';


ALTER FUNCTION public.gtrgm_consistent(gtrgm, internal, integer) OWNER TO trisano_user;

--
-- TOC entry 349 (class 1255 OID 26922)
-- Dependencies: 6
-- Name: gtrgm_decompress(internal); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gtrgm_decompress(internal) RETURNS internal
    LANGUAGE c IMMUTABLE
    AS '$libdir/pg_trgm', 'gtrgm_decompress';


ALTER FUNCTION public.gtrgm_decompress(internal) OWNER TO trisano_user;

--
-- TOC entry 350 (class 1255 OID 26923)
-- Dependencies: 6
-- Name: gtrgm_penalty(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gtrgm_penalty(internal, internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pg_trgm', 'gtrgm_penalty';


ALTER FUNCTION public.gtrgm_penalty(internal, internal, internal) OWNER TO trisano_user;

--
-- TOC entry 351 (class 1255 OID 26924)
-- Dependencies: 6
-- Name: gtrgm_picksplit(internal, internal); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gtrgm_picksplit(internal, internal) RETURNS internal
    LANGUAGE c IMMUTABLE
    AS '$libdir/pg_trgm', 'gtrgm_picksplit';


ALTER FUNCTION public.gtrgm_picksplit(internal, internal) OWNER TO trisano_user;

--
-- TOC entry 352 (class 1255 OID 26925)
-- Dependencies: 6 702 702
-- Name: gtrgm_same(gtrgm, gtrgm, internal); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gtrgm_same(gtrgm, gtrgm, internal) RETURNS internal
    LANGUAGE c IMMUTABLE
    AS '$libdir/pg_trgm', 'gtrgm_same';


ALTER FUNCTION public.gtrgm_same(gtrgm, gtrgm, internal) OWNER TO trisano_user;

--
-- TOC entry 353 (class 1255 OID 26926)
-- Dependencies: 6
-- Name: gtrgm_union(bytea, internal); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION gtrgm_union(bytea, internal) RETURNS integer[]
    LANGUAGE c IMMUTABLE
    AS '$libdir/pg_trgm', 'gtrgm_union';


ALTER FUNCTION public.gtrgm_union(bytea, internal) OWNER TO trisano_user;

--
-- TOC entry 364 (class 1255 OID 35393)
-- Dependencies: 6 1081
-- Name: insert_events_record_number(); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION insert_events_record_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        new.record_number := date_part('year', 'now'::date) || lpad(nextval('events_caseid_seq')::text, 6, '0');
        return new;
    END;
$$;


ALTER FUNCTION public.insert_events_record_number() OWNER TO trisano_su;

--
-- TOC entry 354 (class 1255 OID 26927)
-- Dependencies: 6
-- Name: levenshtein(text, text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION levenshtein(text, text) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/fuzzystrmatch', 'levenshtein';


ALTER FUNCTION public.levenshtein(text, text) OWNER TO trisano_user;

--
-- TOC entry 355 (class 1255 OID 26928)
-- Dependencies: 6
-- Name: metaphone(text, integer); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION metaphone(text, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/fuzzystrmatch', 'metaphone';


ALTER FUNCTION public.metaphone(text, integer) OWNER TO trisano_user;

--
-- TOC entry 359 (class 1255 OID 35376)
-- Dependencies: 1081 6
-- Name: mmwr_week(date); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION mmwr_week(date_in date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    
    DECLARE

        mmwrweek INTEGER;
        fdoy DATE;

    BEGIN
        -- If the events.event_onset_date exists calculate mmwr_year
        IF date_in IS NOT NULL THEN
            
            IF EXTRACT(dow FROM date_in) > 0 THEN
                mmwrweek := EXTRACT(week FROM date_in);
            END IF;

            -- adjust for first day of week discrepancy between iso and cdc
            IF EXTRACT(dow FROM date_in) = 0 THEN
                mmwrweek := EXTRACT(week FROM date_in + interval '1 day');
            END IF;

            IF extract(month from date_in) = 12 THEN
                
                IF extract(day from date_in) = 26 THEN
                    IF extract(dow from date_in) = 0 THEN
                         mmwrweek := EXTRACT(week FROM date_in + interval '1 day');
                    END IF;
                END IF;
                IF extract(day from date_in) = 27 THEN
                    IF extract(dow from date_in) = 0 THEN
                         mmwrweek := EXTRACT(week FROM date_in - interval '1 week') + 2;
                    END IF;
                    IF extract(dow from date_in) = 1 THEN
                         mmwrweek := EXTRACT(week FROM date_in - interval '1 week') + 1;
                    END IF;
                END IF;
                IF extract(day from date_in) = 28 THEN
                    IF extract(dow from date_in) = 0 THEN
                         mmwrweek := EXTRACT(week FROM date_in - interval '1 week') + 2;
                    END IF;
                    IF extract(dow from date_in) IN (1,2) THEN
                         mmwrweek := EXTRACT(week FROM date_in - interval '1 week') + 1;
                    END IF;
                END IF;
                IF extract(day from date_in) = 29 THEN
                    IF extract(dow from date_in) = 0 THEN
                        mmwrweek := 1;
                    ELSE
                         mmwrweek := EXTRACT(week FROM date_in - interval '1 week') + 1;
                    END IF;
                END IF;
                IF extract(day from date_in) = 30 THEN
                    IF extract(dow from date_in) <= 1 THEN
                        mmwrweek := 1;
                    ELSE
                         mmwrweek := EXTRACT(week FROM date_in - interval '1 week') + 1;
                    END IF;
                END IF;
                IF extract(day from date_in) = 31 THEN
                    IF extract(dow from date_in) <= 2 THEN
                        mmwrweek := 1;
                    ELSE
                         mmwrweek := EXTRACT(week FROM date_in - interval '1 week') + 1;
                    END IF;
                END IF;

            END IF;
            IF extract(month from date_in) = 1 THEN
                
                IF extract(day from date_in) = 1 THEN
                    IF extract(dow from date_in) = 4 THEN
                        mmwrweek := 53;
                    END IF;
                    IF extract(dow from date_in) = 5 THEN
                        mmwrweek := 52;
                    END IF;
                    IF extract(dow from date_in) IN (6) THEN
                        mmwrweek := EXTRACT(week FROM date_in - interval '1 day');
                    END IF;
                    IF extract(dow from date_in) IN (0,1,2,3) THEN
                        mmwrweek := 1;
                    END IF;
                END IF;
                IF extract(day from date_in) = 2 THEN
                    IF extract(dow from date_in) IN (1,2,3,4) THEN
                        mmwrweek := 1;
                    END IF;
                    IF extract(dow from date_in) = 5 THEN
                        mmwrweek := EXTRACT(week FROM date_in - interval '1 week') + 1;
                    END IF;
                    IF extract(dow from date_in) = 6 THEN
                        mmwrweek := 52;
                    END IF;
                END IF;
                IF extract(day from date_in) = 3 THEN
                    IF extract(dow from date_in) IN (2,3,4,5) THEN
                        mmwrweek := 1;
                    END IF;
                    IF extract(dow from date_in) = 6 THEN
                        mmwrweek := EXTRACT(week FROM date_in - interval '1 week') + 1;
                    END IF;
                END IF;
                IF extract(day from date_in) = 4 THEN
                    IF extract(dow from date_in) = 6 THEN
                        mmwrweek := 1;
                    END IF;
                END IF;

            END IF;

            SELECT INTO fdoy date '0001-01-01' + interval '1 year' * extract(year from date_in) - interval '1 year';
            IF extract(dow from fdoy) = 4 THEN
                IF extract(day from date_in) >= 4 THEN
                    mmwrweek := mmwrweek - 1;
                END IF;
            END IF;
        END IF;
  
    RETURN mmwrweek;
       
    END;
  
$$;


ALTER FUNCTION public.mmwr_week(date_in date) OWNER TO trisano_su;

--
-- TOC entry 361 (class 1255 OID 35378)
-- Dependencies: 6 1081
-- Name: mmwr_year(date); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION mmwr_year(date_in date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    
    DECLARE

        mmwryear INTEGER;

    BEGIN
        -- If the events.event_onset_date exists calculate mmwr_year
        IF date_in IS NOT NULL THEN
            
            mmwryear = extract(year from date_in);            

            IF extract(month from date_in) = 12 THEN
                
                IF extract(day from date_in) = 29 THEN
                    IF extract(dow from date_in) = 0 THEN 
                        mmwryear := extract(year from date_in) + 1;
                    END IF;
                END IF;
                if extract(day from date_in) = 30 THEN
                    IF extract(dow from date_in) <= 1 THEN
                        mmwryear := extract(year from date_in) + 1;
                    END IF;
                END IF;
                if extract(day from date_in) = 31 THEN
                    IF extract(dow from date_in) <= 2 THEN
                        mmwryear := extract(year from date_in) + 1;
                    END IF;
                END IF;

            END IF;
            
            IF extract(month from date_in) = 1 THEN

                IF extract(day from date_in) = 1 THEN
                    IF extract(dow from date_in) >= 4 THEN 
                        mmwryear := extract(year from date_in) - 1;
                    END IF;
                END IF;
                IF extract(day from date_in) = 2 THEN
                    IF extract(dow from date_in) >= 5 THEN 
                        mmwryear := extract(year from date_in) - 1;
                    END IF;
                END IF;
                IF extract(day from date_in) = 3 THEN
                    IF extract(dow from date_in) >= 6 THEN 
                        mmwryear := extract(year from date_in) - 1;
                    END IF;
                END IF;

            END IF;

        END IF;
  
    RETURN mmwryear;
       
    END;
  
$$;


ALTER FUNCTION public.mmwr_year(date_in date) OWNER TO trisano_su;

--
-- TOC entry 378 (class 1255 OID 35380)
-- Dependencies: 1081 6
-- Name: person_score(character varying, character varying, character varying, character varying, date, date); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION person_score(fn_in character varying, fn_match character varying, ln_in character varying, ln_match character varying, bd_in date, bd_match date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    
    DECLARE

        score INTEGER;
        distance INTEGER;
        distance_fn INTEGER := 0;
        distance_ln INTEGER := 0;
        input_len NUMERIC;
        match_len NUMERIC;
        name_parts_in text[];

    BEGIN
        IF fn_in IS NULL THEN
           fn_in := ''; 
        END IF;
        IF ln_in IS NULL THEN
           ln_in := ''; 
        END IF;

        IF fn_match IS NOT NULL THEN
            distance_fn := levenshtein(lower(trim(fn_in)),lower(trim(fn_match))); 
            IF distance_fn > 0 THEN
                name_parts_in := regexp_split_to_array(trim(both ' ' from fn_in), '[ ,-]');
                FOR c IN 1..3 LOOP 
                    IF position(lower(name_parts_in[c]) in lower(trim(fn_match))) > 0 THEN
                        distance_fn := 4;
                        EXIT;
                    END IF;
                end loop;
            END IF;
        END IF;
        IF fn_match IS NULL THEN
            distance_fn := char_length(trim(fn_in)); 
        END IF;

        IF ln_match IS NOT NULL THEN
            distance_ln := levenshtein(lower(trim(ln_in)),lower(trim(ln_match))); 
            IF distance_ln > 0 THEN
                  name_parts_in := regexp_split_to_array(trim(both ' ' from ln_in), '[ ,-]');
                FOR c IN 1..3 LOOP 
                    IF position(lower(name_parts_in[c]) in lower(ln_match)) > 0 THEN
                        distance_ln := 4;
                        EXIT;
                    END IF;
                end loop;
            END IF;
        END IF;
        IF ln_match IS NULL THEN
            distance_ln := char_length(trim(ln_in)); 
        END IF;

        distance := distance_ln + distance_fn;

        input_len = char_length(trim(fn_in)) + char_length(trim(ln_in));

        IF fn_match IS NOT NULL AND ln_match IS NOT NULL THEN
            match_len := char_length(trim(fn_match)) + char_length(trim(ln_match));
        END IF;
        IF fn_match IS NOT NULL AND ln_match IS NULL THEN
            match_len := char_length(fn_match);
        END IF;
        IF ln_match IS NOT NULL AND fn_match IS NULL THEN
            match_len := char_length(ln_match);
        END IF;

        IF bd_in IS NOT NULL AND bd_match IS NOT NULL  THEN
            distance := distance + levenshtein(to_char(bd_in, 'YYYY-MM-DD'),to_char(bd_match, 'YYYY-MM-DD')); 
            input_len := input_len + 10;
            match_len := match_len + 10;
        END IF;



        IF(input_len > match_len) THEN
            score := round(((input_len - distance) / input_len) * 100);
        END IF;

        IF(input_len <= match_len) THEN
            score := round(((match_len - distance) / match_len) * 100);
        END IF;
        IF bd_in IS NOT NULL AND bd_match IS NULL  THEN
            score := score - 10; 
        END IF;        
    RETURN score;
       
    END;
  
$$;


ALTER FUNCTION public.person_score(fn_in character varying, fn_match character varying, ln_in character varying, ln_match character varying, bd_in date, bd_match date) OWNER TO trisano_su;

--
-- TOC entry 377 (class 1255 OID 35374)
-- Dependencies: 1081 6
-- Name: pg_grant(text, text, text, text); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION pg_grant(usr text, prv text, ptrn text, nsp text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
  num integer;
BEGIN
  num:=0;
  FOR obj IN SELECT relname FROM pg_class c
    JOIN pg_namespace ns ON (c.relnamespace = ns.oid) WHERE
    relkind in ('r','v','S') AND
      nspname = nsp AND
    relname LIKE ptrn
  LOOP
    EXECUTE 'GRANT ' || prv || ' ON ' || obj.relname || ' TO ' || usr;
    num := num + 1;
  END LOOP;
  RETURN num;
END;
$$;


ALTER FUNCTION public.pg_grant(usr text, prv text, ptrn text, nsp text) OWNER TO trisano_su;

--
-- TOC entry 356 (class 1255 OID 26929)
-- Dependencies: 6
-- Name: search_for_name_fts(text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION search_for_name_fts(text) RETURNS SETOF record
    LANGUAGE sql STABLE
    AS $_$
    SELECT id, first_name, last_name,
        ts_rank(
            to_tsvector('simple_no_stop'::regconfig, get_full_name(first_name, last_name)),
            to_tsquery(array_to_string(regexp_split_to_array($1, E'\\s+'), '|'))
        )
    FROM people
        WHERE
        to_tsvector(get_full_name(first_name, last_name)) @@
        to_tsquery(array_to_string(regexp_split_to_array($1, E'\\s+'), '|'))
$_$;


ALTER FUNCTION public.search_for_name_fts(text) OWNER TO trisano_user;

--
-- TOC entry 357 (class 1255 OID 26930)
-- Dependencies: 6
-- Name: search_for_name_trgm(text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION search_for_name_trgm(text) RETURNS SETOF record
    LANGUAGE sql STABLE
    AS $_$
    SELECT id, first_name, last_name,
        ts_rank(get_trigram_tsvector(last_name),
            to_tsquery(array_to_string(show_trgm(lower($1)), '|'::text))
        ) AS rank
    FROM people
    WHERE
        get_trigram_tsvector(last_name) @@
        to_tsquery(array_to_string(show_trgm(lower($1)), '|'::text))
$_$;


ALTER FUNCTION public.search_for_name_trgm(text) OWNER TO trisano_user;

--
-- TOC entry 365 (class 1255 OID 26931)
-- Dependencies: 6
-- Name: search_for_trigram_fts(text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION search_for_trigram_fts(text) RETURNS SETOF record
    LANGUAGE sql STABLE
    AS $_$
    SELECT id, first_name, last_name,
        ts_rank(get_trigram_tsvector(
            get_full_name(first_name, last_name)),
            to_tsquery(array_to_string(show_trgm(lower($1)), '|'::text))) AS rank
    FROM people
    WHERE
        get_trigram_tsvector(get_full_name(first_name, last_name)) @@
        to_tsquery(array_to_string(show_trgm(lower($1)), '|'::text))

        UNION

    SELECT id, first_name, last_name,
        ts_rank(get_trigram_tsvector(first_name),
            to_tsquery(array_to_string(show_trgm(lower($1)), '|'::text))) AS rank
    FROM people
    WHERE
        get_trigram_tsvector(first_name) @@
        to_tsquery(array_to_string(show_trgm(lower($1)), '|'::text))

        UNION

    SELECT id, first_name, last_name,
        ts_rank(get_trigram_tsvector(last_name),
            to_tsquery(array_to_string(show_trgm(lower($1)), '|'::text))) AS rank
    FROM people
    WHERE
        get_trigram_tsvector(last_name) @@
        to_tsquery(array_to_string(show_trgm(lower($1)), '|'::text))
$_$;


ALTER FUNCTION public.search_for_trigram_fts(text) OWNER TO trisano_user;

--
-- TOC entry 387 (class 1255 OID 35389)
-- Dependencies: 6 1081
-- Name: set_event_onset_date(integer); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION set_event_onset_date(event_id_in integer) RETURNS date
    LANGUAGE plpgsql
    AS $$
    
    DECLARE

       new_event_onset_date DATE := null;
       age_and_type VARCHAR := null;
       age VARCHAR := null;
       age_type VARCHAR := null;


    BEGIN

        SELECT get_event_onset_date(event_id_in) INTO new_event_onset_date;
        SELECT get_age_at_onset(event_id_in,new_event_onset_date) INTO age_and_type;--age,type
        SELECT arr[1] FROM regexp_split_to_array(age_and_type,',') as arr INTO age;
        SELECT arr[2] FROM regexp_split_to_array(age_and_type,',') as arr INTO age_type;
        UPDATE events SET event_onset_date = new_event_onset_date, age_at_onset = age::INTEGER, age_type_id = age_type::INTEGER WHERE id = event_id_in;

    RETURN new_event_onset_date;
       
    END;
  
$$;


ALTER FUNCTION public.set_event_onset_date(event_id_in integer) OWNER TO trisano_su;

--
-- TOC entry 366 (class 1255 OID 26932)
-- Dependencies: 1081 6
-- Name: set_events_record_number(); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION set_events_record_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
          BEGIN
            new.record_number := date_part('year', 'now'::date) || lpad(nextval('events_caseid_seq')::text, 6, '0');
            return new;
          END;
        $$;


ALTER FUNCTION public.set_events_record_number() OWNER TO trisano_user;

--
-- TOC entry 367 (class 1255 OID 26933)
-- Dependencies: 6
-- Name: set_limit(real); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION set_limit(real) RETURNS real
    LANGUAGE c STRICT
    AS '$libdir/pg_trgm', 'set_limit';


ALTER FUNCTION public.set_limit(real) OWNER TO trisano_user;

--
-- TOC entry 368 (class 1255 OID 26934)
-- Dependencies: 6
-- Name: show_limit(); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION show_limit() RETURNS real
    LANGUAGE c STABLE STRICT
    AS '$libdir/pg_trgm', 'show_limit';


ALTER FUNCTION public.show_limit() OWNER TO trisano_user;

--
-- TOC entry 369 (class 1255 OID 26935)
-- Dependencies: 6
-- Name: show_trgm(text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION show_trgm(text) RETURNS text[]
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pg_trgm', 'show_trgm';


ALTER FUNCTION public.show_trgm(text) OWNER TO trisano_user;

--
-- TOC entry 370 (class 1255 OID 26936)
-- Dependencies: 6
-- Name: similarity(text, text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION similarity(text, text) RETURNS real
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pg_trgm', 'similarity';


ALTER FUNCTION public.similarity(text, text) OWNER TO trisano_user;

--
-- TOC entry 371 (class 1255 OID 26937)
-- Dependencies: 6
-- Name: similarity_op(text, text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION similarity_op(text, text) RETURNS boolean
    LANGUAGE c STABLE STRICT
    AS '$libdir/pg_trgm', 'similarity_op';


ALTER FUNCTION public.similarity_op(text, text) OWNER TO trisano_user;

--
-- TOC entry 372 (class 1255 OID 26938)
-- Dependencies: 6
-- Name: soundex(text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION soundex(text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/fuzzystrmatch', 'soundex';


ALTER FUNCTION public.soundex(text) OWNER TO trisano_user;

--
-- TOC entry 358 (class 1255 OID 35375)
-- Dependencies: 1081 6
-- Name: street_number_to_name(); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION street_number_to_name() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        -- If the addresses.street_number exists prepend it to the addresses.street_name
        IF NEW.street_number IS NOT NULL THEN
            
            NEW.street_name := trim(both ' ' from trim(both ' ' from NEW.street_number) || ' ' || trim(both ' ' from NEW.street_name));
            NEW.street_number := null;

        END IF;

        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.street_number_to_name() OWNER TO trisano_su;

--
-- TOC entry 373 (class 1255 OID 26939)
-- Dependencies: 6
-- Name: text_soundex(text); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION text_soundex(text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/fuzzystrmatch', 'soundex';


ALTER FUNCTION public.text_soundex(text) OWNER TO trisano_user;

--
-- TOC entry 363 (class 1255 OID 35392)
-- Dependencies: 6 1081
-- Name: update_events_record_number(); Type: FUNCTION; Schema: public; Owner: trisano_su
--

CREATE OR REPLACE FUNCTION update_events_record_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

    BEGIN
        IF new.record_number IS NOT NULL AND old.record_number IS NOT NULL THEN
            new.record_number := old.record_number;
        END IF;
        return new;
    END;
$$;


ALTER FUNCTION public.update_events_record_number() OWNER TO trisano_su;

--
-- TOC entry 374 (class 1255 OID 26940)
-- Dependencies: 1081 6
-- Name: validate_jurisdiction(); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION validate_jurisdiction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    msg TEXT;
    i INTEGER;
BEGIN
    IF NEW.jurisdiction_id IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM places p
            JOIN places_types pt ON (pt.place_id = p.id)
            JOIN codes c ON (c.the_code = 'J' AND c.id = pt.type_id)
        WHERE p.entity_id = NEW.jurisdiction_id
    ) THEN
        RAISE EXCEPTION 'Error. Place with entity id % is not a jurisdiction.', NEW.jurisdiction_id;
        RETURN NULL;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_jurisdiction() OWNER TO trisano_user;

--
-- TOC entry 375 (class 1255 OID 26941)
-- Dependencies: 1081 6
-- Name: validate_participation(); Type: FUNCTION; Schema: public; Owner: trisano_user
--

CREATE OR REPLACE FUNCTION validate_participation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    msg TEXT;
BEGIN
    IF NEW.type = 'Jurisdiction' OR NEW.type = 'AssociatedJurisdiction' THEN
        IF NEW.secondary_entity_id IS NULL THEN
            RETURN NEW;
        END IF;
        PERFORM 1
            FROM places
                JOIN places_types ON places_types.place_id = places.id
                JOIN codes ON places_types.type_id = codes.id AND codes.the_code = 'J'
            WHERE places.entity_id = NEW.secondary_entity_id;
        msg := 'Participation types Jurisdiction and AssociatedJurisdiction must have a jurisdiction in their secondary_entity_id';
    ELSIF NEW.type IN ('Lab', 'ActualDeliveryFacility', 'ReportingAgency', 'DiagnosticFacility', 'ExpectedDeliveryFacility', 'InterestedPlace', 'HospitalizationFacility') THEN
        IF NEW.secondary_entity_id IS NULL THEN
            RETURN NEW;
        END IF;
        PERFORM 1 FROM places WHERE places.entity_id = NEW.secondary_entity_id;
        msg := 'Participation types Lab, ActualDeliveryFacility, ReportingAgency, DiagnosticFacility, ExpectedDeliveryFacility, InterestedPlace, and HospitalizationFacility must have places in their secondary_entity_id';
    ELSIF NEW.type = 'InterestedParty' THEN
        IF NEW.primary_entity_id IS NULL THEN
            RETURN NEW;
        END IF;
        PERFORM 1 FROM people WHERE people.entity_id = NEW.primary_entity_id;
        msg := 'InterestedParty participations must have a place in their primary_entity_id';
    ELSIF NEW.type = 'Clinician' OR NEW.type = 'HealthCareProvider' OR NEW.type = 'Reporter' THEN
        IF NEW.secondary_entity_id IS NULL THEN
            RETURN NEW;
        END IF;
        PERFORM 1 FROM people WHERE people.entity_id = NEW.secondary_entity_id;
        msg := 'Participation types Clinician, HealthCareProvider, and Reporter must have people in their secondary_entity_ids';
    ELSE
        IF NEW.secondary_entity_id IS NULL THEN
            RETURN NEW;
        END IF;
        RAISE EXCEPTION 'Participation is invalid -- unknown type %', NEW.type;
    END IF;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Validation error on participation %: %', NEW.id, msg;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_participation() OWNER TO trisano_user;
