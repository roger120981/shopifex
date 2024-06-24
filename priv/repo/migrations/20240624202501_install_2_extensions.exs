defmodule Shopifex.Repo.Migrations.Install2Extensions20240624202500 do
  @moduledoc """
  Installs any extensions that are mentioned in the repo's `installed_extensions/0` callback

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    execute("CREATE TYPE public.money_with_currency AS (currency_code varchar, amount numeric);")

    execute("""
    CREATE OR REPLACE FUNCTION money_gt(money_1 money_with_currency, money_2 money_with_currency)
    RETURNS BOOLEAN
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        result boolean;
      BEGIN
        IF currency_code(money_1) = currency_code(money_2) THEN
          currency := currency_code(money_1);
          result := amount(money_1) > amount(money_2);
          return result;
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes for > operator. Expected both currency codes to be %', currency_code(money_1)
            USING HINT = 'Please ensure both columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_gt(money_1 money_with_currency, amount numeric)
    RETURNS BOOLEAN
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        result boolean;
      BEGIN
        currency := currency_code(money_1);
        result := amount(money_1) > amount;
        return result;
      END;
    $$;
    """)

    execute("""
    CREATE OPERATOR > (
        leftarg = money_with_currency,
        rightarg = money_with_currency,
        procedure = money_gt
    );
    """)

    execute("""
    CREATE OPERATOR > (
        leftarg = money_with_currency,
        rightarg = numeric,
        procedure = money_gt
    );
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_gte(money_1 money_with_currency, money_2 money_with_currency)
    RETURNS BOOLEAN
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        result boolean;
      BEGIN
        IF currency_code(money_1) = currency_code(money_2) THEN
          currency := currency_code(money_1);
          result := amount(money_1) >= amount(money_2);
          return result;
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes for >= operator. Expected both currency codes to be %', currency_code(money_1)
            USING HINT = 'Please ensure both columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_gte(money_1 money_with_currency, amount numeric)
    RETURNS BOOLEAN
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        result boolean;
      BEGIN
        currency := currency_code(money_1);
        result := amount(money_1) >= amount;
        return result;
      END;
    $$;
    """)

    execute("""
    CREATE OPERATOR >= (
        leftarg = money_with_currency,
        rightarg = money_with_currency,
        procedure = money_gt
    );
    """)

    execute("""
    CREATE OPERATOR >= (
        leftarg = money_with_currency,
        rightarg = numeric,
        procedure = money_gt
    );
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_lt(money_1 money_with_currency, money_2 money_with_currency)
    RETURNS BOOLEAN
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        result boolean;
      BEGIN
        IF currency_code(money_1) = currency_code(money_2) THEN
          currency := currency_code(money_1);
          result := amount(money_1) < amount(money_2);
          return result;
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes for < operator. Expected both currency codes to be %', currency_code(money_1)
            USING HINT = 'Please ensure both columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_lt(money_1 money_with_currency, amount numeric)
    RETURNS BOOLEAN
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        result boolean;
      BEGIN
        currency := currency_code(money_1);
        result := amount(money_1) < amount;
        return result;
      END;
    $$;
    """)

    execute("""
    CREATE OPERATOR < (
        leftarg = money_with_currency,
        rightarg = money_with_currency,
        procedure = money_lt
    );
    """)

    execute("""
    CREATE OPERATOR < (
        leftarg = money_with_currency,
        rightarg = numeric,
        procedure = money_lt
    );
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_lte(money_1 money_with_currency, money_2 money_with_currency)
    RETURNS BOOLEAN
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        result boolean;
      BEGIN
        IF currency_code(money_1) = currency_code(money_2) THEN
          currency := currency_code(money_1);
          result := amount(money_1) <= amount(money_2);
          return result;
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes for <= operator. Expected both currency codes to be %', currency_code(money_1)
            USING HINT = 'Please ensure both columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_lte(money_1 money_with_currency, amount numeric)
    RETURNS BOOLEAN
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        result boolean;
      BEGIN
        currency := currency_code(money_1);
        result := amount(money_1) <= amount;
        return result;
      END;
    $$;
    """)

    execute("""
    CREATE OPERATOR <= (
        leftarg = money_with_currency,
        rightarg = money_with_currency,
        procedure = money_lte
    );
    """)

    execute("""
    CREATE OPERATOR <= (
        leftarg = money_with_currency,
        rightarg = numeric,
        procedure = money_lte
    );
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_sub(money_1 money_with_currency, money_2 money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        subtraction numeric;
      BEGIN
        IF currency_code(money_1) = currency_code(money_2) THEN
          currency := currency_code(money_1);
          subtraction := amount(money_1) - amount(money_2);
          return row(currency, subtraction);
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes for - operator. Expected both currency codes to be %', currency_code(money_1)
            USING HINT = 'Please ensure both columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OPERATOR - (
        leftarg = money_with_currency,
        rightarg = money_with_currency,
        procedure = money_sub,
        commutator = -
    );
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_neg(money_1 money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        addition numeric;
      BEGIN
        currency := currency_code(money_1);
        addition := amount(money_1) * -1;
        return row(currency, addition);
      END;
    $$;
    """)

    execute("""
    CREATE OPERATOR - (
        rightarg = money_with_currency,
        procedure = money_neg
    );
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_add(money_1 money_with_currency, money_2 money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        addition numeric;
      BEGIN
        IF currency_code(money_1) = currency_code(money_2) THEN
          currency := currency_code(money_1);
          addition := amount(money_1) + amount(money_2);
          return row(currency, addition);
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes for + operator. Expected both currency codes to be %', currency_code(money_1)
            USING HINT = 'Please ensure both columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OPERATOR + (
        leftarg = money_with_currency,
        rightarg = money_with_currency,
        procedure = money_add,
        commutator = +
    );
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_min_state_function(agg_state money_with_currency, money money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        expected_currency varchar;
        aggregate numeric;
        min numeric;
      BEGIN
        IF currency_code(agg_state) IS NULL then
          expected_currency := currency_code(money);
          aggregate := 0;
        ELSE
          expected_currency := currency_code(agg_state);
          aggregate := amount(agg_state);
        END IF;

        IF currency_code(money) = expected_currency THEN
          IF amount(money) < aggregate THEN
            min := amount(money);
          ELSE
            min := aggregate;
          END IF;
          return row(expected_currency, min);
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes. Expected all currency codes to be %', expected_currency
            USING HINT = 'Please ensure all columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_min_combine_function(agg_state1 money_with_currency, agg_state2 money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        min numeric;
      BEGIN
        IF currency_code(agg_state1) = currency_code(agg_state2) THEN
          IF amount(agg_state1) < amount(agg_state2) THEN
            min := amount(agg_state1);
          ELSE
            min := amount(agg_state2);
          END IF;
          return row(currency_code(agg_state1), min);
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes. Expected all currency codes to be %', expected_currency
            USING HINT = 'Please ensure all columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE AGGREGATE min(money_with_currency)
    (
      sfunc = money_min_state_function,
      stype = money_with_currency,
      combinefunc = money_min_combine_function,
      parallel = SAFE
    );
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_max_state_function(agg_state money_with_currency, money money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        expected_currency varchar;
        aggregate numeric;
        max numeric;
      BEGIN
        IF currency_code(agg_state) IS NULL then
          expected_currency := currency_code(money);
          aggregate := 0;
        ELSE
          expected_currency := currency_code(agg_state);
          aggregate := amount(agg_state);
        END IF;

        IF currency_code(money) = expected_currency THEN
          IF amount(money) > aggregate THEN
            max := amount(money);
          ELSE
            max := aggregate;
          END IF;
          return row(expected_currency, max);
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes. Expected all currency codes to be %', expected_currency
            USING HINT = 'Please ensure all columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_max_combine_function(agg_state1 money_with_currency, agg_state2 money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        max numeric;
      BEGIN
        IF currency_code(agg_state1) = currency_code(agg_state2) THEN
          IF amount(agg_state1) > amount(agg_state2) THEN
            max := amount(agg_state1);
          ELSE
            max := amount(agg_state2);
          END IF;
          return row(currency_code(agg_state1), max);
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes. Expected all currency codes to be %', expected_currency
            USING HINT = 'Please ensure all columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE AGGREGATE max(money_with_currency)
    (
      sfunc = money_max_state_function,
      stype = money_with_currency,
      combinefunc = money_max_combine_function,
      parallel = SAFE
    );
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_sum_state_function(agg_state money_with_currency, money money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        expected_currency varchar;
        aggregate numeric;
        addition numeric;
      BEGIN
        if currency_code(agg_state) IS NULL then
          expected_currency := currency_code(money);
          aggregate := 0;
        else
          expected_currency := currency_code(agg_state);
          aggregate := amount(agg_state);
        end if;

        IF currency_code(money) = expected_currency THEN
          addition := aggregate + amount(money);
          return row(expected_currency, addition);
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes. Expected all currency codes to be %', expected_currency
            USING HINT = 'Please ensure all columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_sum_combine_function(agg_state1 money_with_currency, agg_state2 money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      BEGIN
        IF currency_code(agg_state1) = currency_code(agg_state2) THEN
          return row(currency_code(agg_state1), amount(agg_state1) + amount(agg_state2));
        ELSE
          RAISE EXCEPTION
            'Incompatible currency codes. Expected all currency codes to be %', expected_currency
            USING HINT = 'Please ensure all columns have the same currency code',
            ERRCODE = '22033';
        END IF;
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE AGGREGATE sum(money_with_currency)
    (
      sfunc = money_sum_state_function,
      stype = money_with_currency,
      combinefunc = money_sum_combine_function,
      parallel = SAFE
    );
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_mult(multiplicator numeric, money money_with_currency)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
      DECLARE
        currency varchar;
        multiplication numeric;
      BEGIN
          currency := currency_code(money);
          multiplication := amount(money) * multiplicator;
          return row(currency, multiplication);
      END;
    $$;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION money_mult_reverse(money money_with_currency, multiplicator numeric)
    RETURNS money_with_currency
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN money_mult(multiplicator, money);
    END;
    $$;
    """)

    execute("""
    CREATE OPERATOR * (
        LEFTARG = numeric,
        RIGHTARG = money_with_currency,
        PROCEDURE = money_mult
    );
    """)

    execute("""
    CREATE OPERATOR * (
        LEFTARG = money_with_currency,
        RIGHTARG = numeric,
        PROCEDURE = money_mult_reverse
    );
    """)

    execute("""
    CREATE OR REPLACE FUNCTION ash_elixir_or(left BOOLEAN, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE)
    AS $$ SELECT COALESCE(NULLIF($1, FALSE), $2) $$
    LANGUAGE SQL
    IMMUTABLE;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION ash_elixir_or(left ANYCOMPATIBLE, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE)
    AS $$ SELECT COALESCE($1, $2) $$
    LANGUAGE SQL
    IMMUTABLE;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION ash_elixir_and(left BOOLEAN, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE) AS $$
      SELECT CASE
        WHEN $1 IS TRUE THEN $2
        ELSE $1
      END $$
    LANGUAGE SQL
    IMMUTABLE;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION ash_elixir_and(left ANYCOMPATIBLE, in right ANYCOMPATIBLE, out f1 ANYCOMPATIBLE) AS $$
      SELECT CASE
        WHEN $1 IS NOT NULL THEN $2
        ELSE $1
      END $$
    LANGUAGE SQL
    IMMUTABLE;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION ash_trim_whitespace(arr text[])
    RETURNS text[] AS $$
    DECLARE
        start_index INT = 1;
        end_index INT = array_length(arr, 1);
    BEGIN
        WHILE start_index <= end_index AND arr[start_index] = '' LOOP
            start_index := start_index + 1;
        END LOOP;

        WHILE end_index >= start_index AND arr[end_index] = '' LOOP
            end_index := end_index - 1;
        END LOOP;

        IF start_index > end_index THEN
            RETURN ARRAY[]::text[];
        ELSE
            RETURN arr[start_index : end_index];
        END IF;
    END; $$
    LANGUAGE plpgsql
    IMMUTABLE;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION ash_raise_error(json_data jsonb)
    RETURNS BOOLEAN AS $$
    BEGIN
        -- Raise an error with the provided JSON data.
        -- The JSON object is converted to text for inclusion in the error message.
        RAISE EXCEPTION 'ash_error: %', json_data::text;
        RETURN NULL;
    END;
    $$ LANGUAGE plpgsql;
    """)

    execute("""
    CREATE OR REPLACE FUNCTION ash_raise_error(json_data jsonb, type_signal ANYCOMPATIBLE)
    RETURNS ANYCOMPATIBLE AS $$
    BEGIN
        -- Raise an error with the provided JSON data.
        -- The JSON object is converted to text for inclusion in the error message.
        RAISE EXCEPTION 'ash_error: %', json_data::text;
        RETURN NULL;
    END;
    $$ LANGUAGE plpgsql;
    """)
  end

  def down do
    # Uncomment this if you actually want to uninstall the extensions
    # when this migration is rolled back:
    execute("DROP OPERATOR >(money_with_currency, money_with_currency);")
    execute("DROP OPERATOR >(money_with_currency, numeric);")

    execute(
      "DROP FUNCTION IF EXISTS money_gt(money_1 money_with_currency, money_2 money_with_currency);"
    )

    execute("DROP FUNCTION IF EXISTS money_gt(money_1 money_with_currency, amount numeric);")
    execute("DROP OPERATOR >=(money_with_currency, money_with_currency);")
    execute("DROP OPERATOR >=(money_with_currency, numeric);")

    execute(
      "DROP FUNCTION IF EXISTS money_gte(money_1 money_with_currency, money_2 money_with_currency);"
    )

    execute("DROP FUNCTION IF EXISTS money_gte(money_1 money_with_currency, amount numeric);")
    execute("DROP OPERATOR <(money_with_currency, money_with_currency);")
    execute("DROP OPERATOR <(money_with_currency, numeric);")

    execute(
      "DROP FUNCTION IF EXISTS money_lt(money_1 money_with_currency, money_2 money_with_currency);"
    )

    execute("DROP FUNCTION IF EXISTS money_lt(money_1 money_with_currency, amount numeric);")
    execute("DROP OPERATOR <=(money_with_currency, money_with_currency);")
    execute("DROP OPERATOR <=(money_with_currency, numeric);")

    execute(
      "DROP FUNCTION IF EXISTS money_lte(money_1 money_with_currency, money_2 money_with_currency);"
    )

    execute("DROP FUNCTION IF EXISTS money_lte(money_1 money_with_currency, amount numeric);")
    execute("DROP OPERATOR - (money_with_currency, money_with_currency);")

    execute(
      "DROP FUNCTION IF EXISTS money_sub(money_1 money_with_currency, money_2 money_with_currency);"
    )

    execute("DROP OPERATOR -(none, money_with_currency);")
    execute("DROP FUNCTION IF EXISTS money_neg(money_1 money_with_currency);")
    execute("DROP OPERATOR * (money_with_currency, numeric);")
    execute("DROP OPERATOR * (numeric, money_with_currency);")

    execute(
      "DROP FUNCTION IF EXISTS money_mult(multiplicator numeric, money money_with_currency);"
    )

    execute(
      "DROP FUNCTION IF EXISTS money_mult(money money_with_currency, multiplicator numeric);"
    )

    execute("DROP AGGREGATE IF EXISTS sum(money_with_currency);")

    execute(
      "DROP FUNCTION IF EXISTS money_sum_combine_function(agg_state1 money_with_currency, agg_state2 money_with_currency);"
    )

    execute(
      "DROP FUNCTION IF EXISTS money_sum_state_function(agg_state money_with_currency, money money_with_currency);"
    )

    execute("DROP AGGREGATE IF EXISTS max(money_with_currency);")

    execute(
      "DROP FUNCTION IF EXISTS money_max_combine_function(agg_state1 money_with_currency, agg_state2 money_with_currency);"
    )

    execute(
      "DROP FUNCTION IF EXISTS money_max_state_function(agg_state money_with_currency, money money_with_currency);"
    )

    execute("DROP AGGREGATE IF EXISTS min(money_with_currency);")

    execute(
      "DROP FUNCTION IF EXISTS money_min_combine_function(agg_state1 money_with_currency, agg_state2 money_with_currency);"
    )

    execute(
      "DROP FUNCTION IF EXISTS money_min_state_function(agg_state money_with_currency, money money_with_currency);"
    )

    execute("DROP OPERATOR + (money_with_currency, money_with_currency);")

    execute(
      "DROP FUNCTION IF EXISTS money_add(money_1 money_with_currency, money_2 money_with_currency);"
    )

    execute("DROP TYPE public.money_with_currency;")

    execute(
      "DROP FUNCTION IF EXISTS ash_raise_error(jsonb), ash_raise_error(jsonb, ANYCOMPATIBLE), ash_elixir_and(BOOLEAN, ANYCOMPATIBLE), ash_elixir_and(ANYCOMPATIBLE, ANYCOMPATIBLE), ash_elixir_or(ANYCOMPATIBLE, ANYCOMPATIBLE), ash_elixir_or(BOOLEAN, ANYCOMPATIBLE), ash_trim_whitespace(text[])"
    )
  end
end
