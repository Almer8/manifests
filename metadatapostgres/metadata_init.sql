CREATE SCHEMA IF NOT EXISTS public;
CREATE TABLE IF NOT EXISTS public.estimate
(
    id bigint NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    orgId bigint NOT NULL,
    color character varying(255) COLLATE pg_catalog."default" NOT NULL,
    title character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT estimate_pkey PRIMARY KEY (id)
    )

    TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.organization
(
    id bigint NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    ownerId bigint NOT NULL,
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    title character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT organization_pkey PRIMARY KEY (id),
    CONSTRAINT organization_name_key UNIQUE (name)
    )

    TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.priority
(
    id bigint NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    orgId bigint NOT NULL,
    color character varying(255) COLLATE pg_catalog."default" NOT NULL,
    title character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT priority_pkey PRIMARY KEY (id)
    )

    TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.project
(
    id bigint NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    orgId bigint NOT NULL,
    ownerId bigint NOT NULL,
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    title character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT project_pkey PRIMARY KEY (id)
    )

    TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.status
(
    id bigint NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    orgId bigint NOT NULL,
    color character varying(255) COLLATE pg_catalog."default" NOT NULL,
    title character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT status_pkey PRIMARY KEY (id)
    )

    TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.tag
(
    id bigint NOT NULL GENERATED BY DEFAULT AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    orgId bigint NOT NULL,
    color character varying(255) COLLATE pg_catalog."default" NOT NULL,
    title character varying(255) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT tag_pkey PRIMARY KEY (id)
    )

    TABLESPACE pg_default;


ALTER TABLE IF EXISTS public.estimate
    OWNER to postgres;
ALTER TABLE IF EXISTS public.organization
    OWNER to postgres;
ALTER TABLE IF EXISTS public.priority
    OWNER to postgres;
ALTER TABLE IF EXISTS public.project
    OWNER to postgres;
ALTER TABLE IF EXISTS public.status
    OWNER to postgres;
ALTER TABLE IF EXISTS public.tag
    OWNER to postgres;

GRANT ALL ON TABLE public.estimate TO postgres;
GRANT ALL ON TABLE public.organization TO postgres;
GRANT ALL ON TABLE public.priority TO postgres;
GRANT ALL ON TABLE public.project TO postgres;
GRANT ALL ON TABLE public.status TO postgres;
GRANT ALL ON TABLE public.tag TO postgres;

CREATE OR REPLACE FUNCTION notify_change() RETURNS TRIGGER AS $$
DECLARE
action TEXT;
    record JSONB;
BEGIN
    IF TG_OP = 'INSERT' THEN
        action := 'CREATE';
        record := row_to_json(NEW)::jsonb;
        PERFORM pg_notify('data_changes', json_build_object(
            'action', action,
            'type', TG_TABLE_NAME,
            'data', record
        )::text);
RETURN NEW;
ELSIF TG_OP = 'UPDATE' THEN
        action := 'UPDATE';
        record := row_to_json(NEW)::jsonb;
        PERFORM pg_notify('data_changes', json_build_object(
            'action', action,
            'type', TG_TABLE_NAME,
            'data', record
        )::text);
RETURN NEW;
ELSIF TG_OP = 'DELETE' THEN
        action := 'DELETE';
        record := row_to_json(OLD)::jsonb;
        PERFORM pg_notify('data_changes', json_build_object(
            'action', action,
            'type', TG_TABLE_NAME,
            'data', record
        )::text);
RETURN OLD;
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER org_change_trigger
    AFTER INSERT OR UPDATE OR DELETE ON organization
    FOR EACH ROW EXECUTE FUNCTION notify_change();

CREATE OR REPLACE TRIGGER proj_change_trigger
    AFTER INSERT OR UPDATE OR DELETE ON project
    FOR EACH ROW EXECUTE FUNCTION notify_change();