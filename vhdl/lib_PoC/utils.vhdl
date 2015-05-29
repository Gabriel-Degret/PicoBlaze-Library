-- EMACS settings: -*-  tab-width: 2; indent-tabs-mode: t -*-
-- vim: tabstop=2:shiftwidth=2:noexpandtab
-- kate: tab-width 2; replace-tabs off; indent-width 2;
-- 
-- ============================================================================
-- Package:					Common functions and types
--
-- Authors:					Thomas B. Preusser
--									Martin Zabel
--									Patrick Lehmann
--
-- Description:
-- ------------------------------------
--		For detailed documentation see below.
--
-- License:
-- ============================================================================
-- Copyright 2007-2014 Technische Universitaet Dresden - Germany
--										 Chair for VLSI-Design, Diagnostics and Architecture
-- 
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- 
--		http://www.apache.org/licenses/LICENSE-2.0
-- 
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- ============================================================================

library	IEEE;

use			IEEE.std_logic_1164.all;
use			IEEE.numeric_std.all;

library	PoC;


package utils is
  --+ Environment +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  -- Distinguishes Simulation from Synthesis
	function SIMULATION return boolean;
	
	-- Type declarations
	-- ==========================================================================
	
  --+ Vectors of primitive standard types +++++++++++++++++++++++++++++++++++++
	TYPE		T_BOOLVEC						IS ARRAY(NATURAL RANGE <>) OF BOOLEAN;
	TYPE		T_INTVEC						IS ARRAY(NATURAL RANGE <>) OF INTEGER;
	TYPE		T_NATVEC						IS ARRAY(NATURAL RANGE <>) OF NATURAL;
	TYPE		T_POSVEC						IS ARRAY(NATURAL RANGE <>) OF POSITIVE;
	TYPE		T_REALVEC						IS ARRAY(NATURAL RANGE <>) OF REAL;
	
	--+ Integer subranges sometimes useful for speeding up simulation ++++++++++
	SUBTYPE T_INT_8							IS INTEGER RANGE -128 TO 127;
	SUBTYPE T_INT_16						IS INTEGER RANGE -32768 TO 32767;
	SUBTYPE T_UINT_8						IS INTEGER RANGE 0 TO 255;
	SUBTYPE T_UINT_16						IS INTEGER RANGE 0 TO 65535;

	--+ Enums ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-- Intellectual Property (IP) type
	type T_IPSTYLE				is (IPSTYLE_HARD, IPSTYLE_SOFT);
	
	-- Bit Order
	type T_BIT_ORDER			is (LSB_FIRST, MSB_FIRST);
  
	-- Byte Order (Endian)
	type T_BYTE_ORDER			is (LITTLE_ENDIAN, BIG_ENDIAN);
	
	-- rounding style
	type T_ROUNDING_STYLE	is (ROUND_TO_NEAREST, ROUND_TO_ZERO, ROUND_TO_INF, ROUND_UP, ROUND_DOWN);

	-- Function declarations
	-- ==========================================================================

  --+ Division ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  -- Calculates: ceil(a / b)
	FUNCTION div_ceil(a : NATURAL; b : POSITIVE) RETURN NATURAL;
	
  --+ Power +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  -- is input a power of 2?
	FUNCTION is_pow2(int : NATURAL)			RETURN BOOLEAN;
  -- round to next power of 2
	FUNCTION ceil_pow2(int : NATURAL)		RETURN POSITIVE;
  -- round to previous power of 2
	FUNCTION floor_pow2(int : NATURAL)	RETURN NATURAL;

  --+ Logarithm ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  -- Calculates: ceil(ld(arg))
  function log2ceil(arg : positive) return natural;
  -- Calculates: max(1, ceil(ld(arg)))
  function log2ceilnz(arg : positive) return positive;
  -- Calculates: ceil(lg(arg))
	FUNCTION log10ceil(arg		: POSITIVE)	RETURN NATURAL;
  -- Calculates: max(1, ceil(lg(arg)))
	FUNCTION log10ceilnz(arg	: POSITIVE)	RETURN POSITIVE;
	
	--+ if-then-else (ite) +++++++++++++++++++++++++++++++++++++++++++++++++++++
	function ite(cond : BOOLEAN; value1 : INTEGER; value2 : INTEGER) return INTEGER;
	function ite(cond : BOOLEAN; value1 : REAL;	value2 : REAL) return REAL;
	function ite(cond : BOOLEAN; value1 : STD_LOGIC; value2 : STD_LOGIC) return STD_LOGIC;
	function ite(cond : BOOLEAN; value1 : STD_LOGIC_VECTOR; value2 : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
	function ite(cond : BOOLEAN; value1 : UNSIGNED; value2 : UNSIGNED) return UNSIGNED;
	function ite(cond : BOOLEAN; value1 : CHARACTER; value2 : CHARACTER) return CHARACTER;
	function ite(cond : BOOLEAN; value1 : STRING; value2 : STRING) return STRING;

  --+ Max / Min / Sum ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	function imin(arg1 : integer; arg2 : integer) return integer;		-- Calculates: min(arg1, arg2) for integers
	function rmin(arg1 : real; arg2 : real) return real;						-- Calculates: min(arg1, arg2) for reals
	
	function imin(vec : T_INTVEC) return INTEGER;										-- Calculates: min(vec) for a integer vector
	function imin(vec : T_NATVEC) return NATURAL;										-- Calculates: min(vec) for a natural vector
	function imin(vec : T_POSVEC) return POSITIVE;									-- Calculates: min(vec) for a positive vector
	function rmin(vec : T_REALVEC) return real;	       							-- Calculates: min(vec) of real vector

	function imax(arg1 : integer; arg2 : integer) return integer;		-- Calculates: max(arg1, arg2) for integers
	function rmax(arg1 : real; arg2 : real) return real;						-- Calculates: max(arg1, arg2) for reals
	
	function imax(vec : T_INTVEC) return INTEGER;										-- Calculates: max(vec) for a integer vector
	function imax(vec : T_NATVEC) return NATURAL;										-- Calculates: max(vec) for a natural vector
	function imax(vec : T_POSVEC) return POSITIVE;									-- Calculates: max(vec) for a positive vector
	function rmax(vec : T_REALVEC) return real;	       							-- Calculates: max(vec) of real vector

	function isum(vec : T_NATVEC) return NATURAL;										-- Calculates: sum(vec) for a natural vector
	function isum(vec : T_POSVEC) return POSITIVE;									-- Calculates: sum(vec) for a positive vector
	function isum(vec : T_INTVEC) return integer; 									-- Calculates: sum(vec) of integer vector
	function rsum(vec : T_REALVEC) return real;	       							-- Calculates: sum(vec) of real vector

	-- compare
	function comp(value1 : STD_LOGIC_VECTOR; value2 : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR;
	function comp(value1 : UNSIGNED; value2 : UNSIGNED) return UNSIGNED;
	function comp(value1 : SIGNED; value2 : SIGNED) return SIGNED;

	--+ Conversions ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  -- To std_logic: to_sl
	FUNCTION to_sl(Value : BOOLEAN)		RETURN STD_LOGIC;
	FUNCTION to_sl(Value : CHARACTER) RETURN STD_LOGIC;

	-- To std_logic_vector: to_slv
	FUNCTION to_slv(Value : NATURAL; Size : POSITIVE)		RETURN STD_LOGIC_VECTOR;					-- short for std_logic_vector(to_unsigned(Value, Size))
	
	-- TODO: comment
	FUNCTION to_index(slv : UNSIGNED; max : NATURAL := 0) RETURN INTEGER;
	FUNCTION to_index(slv : STD_LOGIC_VECTOR; max : NATURAL := 0) RETURN INTEGER;
	
	-- is_*
	FUNCTION is_sl(c : CHARACTER) RETURN BOOLEAN;

	--+ Basic Vector Utilities +++++++++++++++++++++++++++++++++++++++++++++++++

  -- Aggregate Functions
  FUNCTION slv_or  (vec : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
  FUNCTION slv_nor (vec : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
  FUNCTION slv_and (vec : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
  FUNCTION slv_nand(vec : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
  function slv_xor (vec : std_logic_vector) return std_logic;
	-- NO slv_xnor! This operation would not be well-defined as
	-- not xor(vec) /= vec_{n-1} xnor ... xnor vec_1 xnor vec_0 iff n is odd.

  -- Reverses the elements of the passed Vector.
  --
  -- @synthesis supported
  --
	function reverse(vec : std_logic_vector) return std_logic_vector;
	function reverse(vec : bit_vector) return bit_vector;
	function reverse(vec : unsigned) return unsigned;
	
  -- Resizes the vector to the specified length. The adjustment is make on
  -- on the 'high end of the vector. The 'low index remains as in the argument.
  -- If the result vector is larger, the extension uses the provided fill value
  -- (default: '0').
	-- Use the resize functions of the numeric_std package for value-preserving
	-- resizes of the signed and unsigned data types.
	--
  -- @synthesis supported
  --
  function resize(vec : bit_vector; length : natural; fill : bit := '0')
    return bit_vector;
  function resize(vec : std_logic_vector; length : natural; fill : std_logic := '0')
    return std_logic_vector;

	-- Shift the index range of a vector by the specified offset.
	function move(vec : std_logic_vector; ofs : integer) return std_logic_vector;

	-- Shift the index range of a vector making vec'low = 0.
	function movez(vec : std_logic_vector) return std_logic_vector;

  function ascend(vec : std_logic_vector) return std_logic_vector;
  function descend(vec : std_logic_vector) return std_logic_vector;
	
  -- Least-Significant Set Bit (lssb):
  -- Computes a vector of the same length as the argument with
  -- at most one bit set at the rightmost '1' found in arg.
  --
  -- @synthesis supported
  --
  function lssb(arg : std_logic_vector) return std_logic_vector;
  function lssb(arg : bit_vector) return bit_vector;

  -- Returns the position of the least-significant set bit assigning
  -- the rightmost position an index of zero (0).
  --
  -- @synthesis supported
  --
  function lssb_idx(arg : std_logic_vector) return integer;
  function lssb_idx(arg : bit_vector) return integer;

	-- Most-Significant Set Bit (mssb): computes a vector of the same length
	-- with at most one bit set at the leftmost '1' found in arg.
	function mssb(arg : std_logic_vector) return std_logic_vector;
  function mssb(arg : bit_vector) return bit_vector;
	function mssb_idx(arg : std_logic_vector) return integer;
  function mssb_idx(arg : bit_vector) return integer;

	-- Swap sub vectors in vector (endian reversal)
	FUNCTION swap(slv : STD_LOGIC_VECTOR; Size : POSITIVE) RETURN STD_LOGIC_VECTOR;

	-- generate bit masks
	FUNCTION genmask_high(Bits : NATURAL; MaskLength : POSITIVE) RETURN STD_LOGIC_VECTOR;
	FUNCTION genmask_low(Bits : NATURAL; MaskLength : POSITIVE) RETURN STD_LOGIC_VECTOR;

	--+ Encodings ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  -- One-Hot-Code to Binary-Code.
	function onehot2bin(onehot : std_logic_vector) return unsigned;

  -- Converts Gray-Code into Binary-Code.
  --
  -- @synthesis supported
  --
  function gray2bin (gray_val : std_logic_vector) return std_logic_vector;
	
	-- Binary-Code to One-Hot-Code
	function bin2onehot(value : std_logic_vector) return std_logic_vector;
	
	-- Binary-Code to Gray-Code
	function bin2gray(value : std_logic_vector) return std_logic_vector;
	
end package utils;


package body utils is

	-- Environment
	-- ==========================================================================
	function SIMULATION return boolean is
		variable ret : boolean;
	begin
		ret := false;
		--synthesis translate_off
		if Is_X('X') then ret := true; end if;
		--synthesis translate_on
		return	ret;
	end function;

	-- Divisions: div_*
	FUNCTION div_ceil(a : NATURAL; b : POSITIVE) RETURN NATURAL IS	-- calculates: ceil(a / b)
	BEGIN
		RETURN (a + (b - 1)) / b;
	END FUNCTION;

	-- Power functions: *_pow2
	-- ==========================================================================
	-- is input a power of 2?
	FUNCTION is_pow2(int : NATURAL) RETURN BOOLEAN IS
	BEGIN
		RETURN ceil_pow2(int) = int;
	END FUNCTION;
	
	-- round to next power of 2
	FUNCTION ceil_pow2(int : NATURAL) RETURN POSITIVE IS
	BEGIN
		RETURN 2 ** log2ceil(int);
	END FUNCTION;
	
	-- round to previous power of 2
	FUNCTION floor_pow2(int : NATURAL) RETURN NATURAL IS
		VARIABLE temp : UNSIGNED(30 DOWNTO 0)	:= to_unsigned(int, 31);
	BEGIN
		FOR I IN temp'range LOOP
			IF (temp(I) = '1') THEN
				RETURN 2 ** I;
			END IF;
		END LOOP;
		RETURN 0;
	END FUNCTION;

	-- Logarithms: log*ceil*
	-- ==========================================================================
	function log2ceil(arg : positive) return natural is
		variable tmp : positive		:= 1;
		variable log : natural		:= 0;
	begin
		if arg = 1 then	return 0; end if;
		while arg > tmp loop
			tmp := tmp * 2;
			log := log + 1;
		end loop;
		return log;
	end function;

	function log2ceilnz(arg : positive) return positive is
	begin
		return imax(1, log2ceil(arg));
	end function;

	function log10ceil(arg : positive) return natural is
		variable tmp : positive		:= 1;
		variable log : natural		:= 0;
	begin
		if arg = 1 then	return 0; end if;
		while arg > tmp loop
			tmp := tmp * 10;
			log := log + 1;
		end loop;
		return log;
	end function;

	function log10ceilnz(arg : positive) return positive is
	begin
		return imax(1, log10ceil(arg));
	end function;

	-- if-then-else (ite)
	-- ==========================================================================
	function ite(cond : BOOLEAN; value1 : INTEGER; value2 : INTEGER) return INTEGER is
	begin
		if cond then
			return value1;
		else
			return value2;
		end if;
	end function;

	function ite(cond : BOOLEAN; value1 : REAL; value2 : REAL) return REAL is
	begin
		if cond then
			return value1;
		else
			return value2;
		end if;
	end function;

	function ite(cond : BOOLEAN; value1 : STD_LOGIC; value2 : STD_LOGIC) return STD_LOGIC is
	begin
		if cond then
			return value1;
		else
			return value2;
		end if;
	end function;

	function ite(cond : BOOLEAN; value1 : STD_LOGIC_VECTOR; value2 : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
	begin
		if cond then
			return value1;
		else
			return value2;
		end if;
	end function;

	function ite(cond : BOOLEAN; value1 : UNSIGNED; value2 : UNSIGNED) return UNSIGNED is
	begin
		if cond then
			return value1;
		else
			return value2;
		end if;
	end function;

	function ite(cond : BOOLEAN; value1 : CHARACTER; value2 : CHARACTER) return CHARACTER is
	begin
		if cond then
			return value1;
		else
			return value2;
		end if;
	end function;
	
	function ite(cond : BOOLEAN; value1 : STRING; value2 : STRING) return STRING is
	begin
		if cond then
			return value1;
		else
			return value2;
		end if;
	end function;
	
	-- *min / *max / *sum
	-- ==========================================================================
	function imin(arg1 : integer; arg2 : integer) return integer is
	begin
		if arg1 < arg2 then return arg1; end if;
		return arg2;
	end function;

	function rmin(arg1 : real; arg2 : real) return real is
	begin
		if arg1 < arg2 then return arg1; end if;
		return arg2;
	end function;
	
	FUNCTION imin(vec : T_INTVEC) RETURN INTEGER IS
		VARIABLE Result		: INTEGER		:= INTEGER'high;
	BEGIN
		FOR I IN vec'range LOOP
			IF (vec(I) < Result) THEN
				Result	:= vec(I);
			END IF;
		END LOOP;
		RETURN Result;
	END FUNCTION;
	
	FUNCTION imin(vec : T_NATVEC) RETURN NATURAL IS
		VARIABLE Result		: natural := NATURAL'high;
	BEGIN
		FOR I IN vec'range LOOP
			IF (vec(I) < Result) THEN
				Result	:= vec(I);
			END IF;
		END LOOP;
		RETURN Result;
	END FUNCTION;
	
	FUNCTION imin(vec : T_POSVEC) RETURN POSITIVE IS
		VARIABLE Result		: positive := POSITIVE'high;
	BEGIN
		FOR I IN vec'range LOOP
			IF (vec(I) < Result) THEN
				Result	:= vec(I);
			END IF;
		END LOOP;
		RETURN Result;
	END FUNCTION;

	function rmin(vec : T_REALVEC) return real is
		variable  res : real := real'high;
	begin
		for i in vec'range loop
			if vec(i) < res then
				res := vec(i);
			end if;
		end loop;
		return  res;
	end rmin;

	function imax(arg1 : integer; arg2 : integer) return integer is
	begin
		if arg1 > arg2 then return arg1; end if;
		return arg2;
	end function;

	function rmax(arg1 : real; arg2 : real) return real is
	begin
		if arg1 > arg2 then return arg1; end if;
		return arg2;
	end function;
	
	FUNCTION imax(vec : T_INTVEC) RETURN INTEGER IS
		VARIABLE Result		: INTEGER		:= INTEGER'low;
	BEGIN
		FOR I IN vec'range LOOP
			IF (vec(I) > Result) THEN
				Result	:= vec(I);
			END IF;
		END LOOP;
		RETURN Result;
	END FUNCTION;
	
	FUNCTION imax(vec : T_NATVEC) RETURN NATURAL IS
		VARIABLE Result		: natural := NATURAL'low;
	BEGIN
		FOR I IN vec'range LOOP
			IF (vec(I) > Result) THEN
				Result	:= vec(I);
			END IF;
		END LOOP;
		RETURN Result;
	END FUNCTION;
	
	FUNCTION imax(vec : T_POSVEC) RETURN POSITIVE IS
		VARIABLE Result		: positive := POSITIVE'low;
	BEGIN
		FOR I IN vec'range LOOP
			IF (vec(I) > Result) THEN
				Result	:= vec(I);
			END IF;
		END LOOP;
		RETURN Result;
	END FUNCTION;

	function rmax(vec : T_REALVEC) return real is
		variable  res : real := real'low;
	begin
		for i in vec'range loop
			if vec(i) > res then
				res := vec(i);
			end if;
		end loop;
		return  res;
	end rmax;

	FUNCTION isum(vec : T_NATVEC) RETURN NATURAL IS
		VARIABLE Result		: NATURAL		:= 0;
	BEGIN
		FOR I IN vec'range LOOP
			Result	:= Result + vec(I);
		END LOOP;
		RETURN Result;
	END FUNCTION;
	
	FUNCTION isum(vec : T_POSVEC) RETURN POSITIVE IS
		VARIABLE Result		: NATURAL	:= 0;
	BEGIN
		FOR I IN vec'range LOOP
			Result	:= Result + vec(I);
		END LOOP;
		RETURN Result;
	END FUNCTION;

	function isum(vec : T_INTVEC) return integer is
		variable  res : integer := 0;
	begin
		for i in vec'range loop
			res	:= res + vec(i);
		end loop;
		return  res;
	end isum;

	function rsum(vec : T_REALVEC) return real is
		variable  res : real := 0.0;
	begin
		for i in vec'range loop
			res	:= res + vec(i);
		end loop;
		return  res;
	end rsum;

	-- Vector aggregate functions: slv_*
	-- ==========================================================================
	FUNCTION slv_or(vec : STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
		VARIABLE Result : STD_LOGIC := '0';
	BEGIN
		FOR i IN vec'range LOOP
			Result	:= Result OR vec(i);
		END LOOP;
		RETURN Result;
	END FUNCTION;

	FUNCTION slv_nor(vec : STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
	BEGIN
		RETURN NOT slv_or(vec);
	END FUNCTION;

	FUNCTION slv_and(vec : STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
		VARIABLE Result : STD_LOGIC := '1';
	BEGIN
		FOR i IN vec'range LOOP
			Result	:= Result AND vec(i);
		END LOOP;
		RETURN Result;
	END FUNCTION;

	FUNCTION slv_nand(vec : STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
	BEGIN
		RETURN NOT slv_and(vec);
	END FUNCTION;

	function slv_xor(vec : std_logic_vector) return std_logic is
		variable  res : std_logic;
	begin
		res := '0';
		for i in vec'range loop
			res := res xor vec(i);
		end loop;
		return  res;
	end slv_xor;
	
	-- compare functions
	-- return value 1- => value1 < value2 (difference is negative)
	-- return value 00 => value1 = value2 (difference is zero)
	-- return value -1 => value1 > value2 (difference is positive)
	function comp(value1 : STD_LOGIC_VECTOR; value2 : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
	begin
		return std_logic_vector(comp(unsigned(value1), unsigned(value2)));
	end function;
	
	function comp(value1 : UNSIGNED; value2 : UNSIGNED) return UNSIGNED is
	begin
		if (value1 < value2) then
			return "10";
		elsif (value1 = value2) then
			return "00";
		else
			return "01";
		end if;
	end function;

	function comp(value1 : SIGNED; value2 : SIGNED) return SIGNED is
	begin
		if (value1 < value2) then
			return "10";
		elsif (value1 = value2) then
			return "00";
		else
			return "01";
		end if;
	end function;
	
	-- Convert to bit: to_sl
	-- ==========================================================================
	FUNCTION to_sl(Value : BOOLEAN) RETURN STD_LOGIC IS
	BEGIN
		RETURN ite(Value, '1', '0');
	END FUNCTION;

	FUNCTION to_sl(Value : CHARACTER) RETURN STD_LOGIC IS
	BEGIN
		CASE Value IS
			WHEN 'U' =>			RETURN 'U';
			WHEN '0' =>			RETURN '0';
			WHEN '1' =>			RETURN '1';
			WHEN 'Z' =>			RETURN 'Z';
			WHEN 'W' =>			RETURN 'W';
			WHEN 'L' =>			RETURN 'L';
			WHEN 'H' =>			RETURN 'H';
			WHEN '-' =>			RETURN '-';
			WHEN OTHERS =>	RETURN 'X';
		END CASE;
	END FUNCTION;

	-- Convert to vector: to_slv
	-- ==========================================================================
	-- short for std_logic_vector(to_unsigned(Value, Size))
	-- the return value is guaranteed to have the range (Size-1 downto 0)
	FUNCTION to_slv(Value : NATURAL; Size : POSITIVE) RETURN STD_LOGIC_VECTOR IS
	  constant  res : std_logic_vector(Size-1 downto 0) := std_logic_vector(to_unsigned(Value, Size));
	BEGIN
		return  res;
	END FUNCTION;

	FUNCTION to_index(slv : UNSIGNED; max : NATURAL := 0) RETURN INTEGER IS
		variable  res : integer;
	BEGIN
		if (slv'length = 0) then	return 0;	end if;
	
		res := to_integer(slv);
		if SIMULATION and max > 0 then
			res := imin(res, max);
		end if;
		return  res;
	END FUNCTION;

	FUNCTION to_index(slv : STD_LOGIC_VECTOR; max : NATURAL := 0) RETURN INTEGER IS
	BEGIN
		RETURN to_index(unsigned(slv), max);
	END FUNCTION;
	
  -- is_*
  -- ==========================================================================
  FUNCTION is_sl(c : CHARACTER) RETURN BOOLEAN IS
  BEGIN
    CASE C IS
      WHEN 'U'|'X'|'0'|'1'|'Z'|'W'|'L'|'H'|'-' => return  true;
      WHEN OTHERS                              => return  false;
    END CASE;
  END FUNCTION;

	
	-- Reverse vector elements
	function reverse(vec : std_logic_vector) return std_logic_vector is
		variable res : std_logic_vector(vec'range);
	begin
		for i in vec'low to vec'high loop
			res(vec'low + (vec'high-i)) := vec(i);
		end loop;
		return	res;
	end function;
	
	function reverse(vec : bit_vector) return bit_vector is
		variable res : bit_vector(vec'range);
	begin
    res := to_bitvector(reverse(to_stdlogicvector(vec)));
    return  res;
	end reverse;
	
	function reverse(vec : unsigned) return unsigned is
	begin
		return unsigned(reverse(std_logic_vector(vec)));
	end function;

	
	-- Swap sub vectors in vector
	-- ==========================================================================
	FUNCTION swap(slv : STD_LOGIC_VECTOR; Size : POSITIVE) RETURN STD_LOGIC_VECTOR IS
		CONSTANT SegmentCount	: NATURAL													:= slv'length / Size;
		VARIABLE FromH				: NATURAL;
		VARIABLE FromL				: NATURAL;
		VARIABLE ToH					: NATURAL;
		VARIABLE ToL					: NATURAL;
		VARIABLE Result : STD_LOGIC_VECTOR(slv'length - 1 DOWNTO 0);
	BEGIN
		FOR I IN 0 TO SegmentCount - 1 LOOP
			FromH		:= ((I + 1) * Size) - 1;
			FromL		:= I * Size;
			ToH			:= ((SegmentCount - I) * Size) - 1;
			ToL			:= (SegmentCount - I - 1) * Size;
			Result(ToH DOWNTO ToL)	:= slv(FromH DOWNTO FromL);
		END LOOP;
		RETURN Result;
	END FUNCTION;

	-- generate bit masks
	-- ==========================================================================
		FUNCTION genmask_high(Bits : NATURAL; MaskLength : POSITIVE) RETURN STD_LOGIC_VECTOR IS
	BEGIN
		IF (Bits = 0) THEN
			RETURN (MaskLength - 1 DOWNTO 0 => '0');
		ELSE	
			RETURN (MaskLength - 1 DOWNTO MaskLength - Bits + 1 => '1') & (MaskLength - Bits DOWNTO 0 => '0');
		END IF;
	END FUNCTION;

	FUNCTION genmask_low(Bits : NATURAL; MaskLength : POSITIVE) RETURN STD_LOGIC_VECTOR IS
	BEGIN
		IF (Bits = 0) THEN
			RETURN (MaskLength - 1 DOWNTO 0 => '0');
		ELSE	
			RETURN (MaskLength - 1 DOWNTO Bits => '0') & (Bits - 1 DOWNTO 0 => '1');
		END IF;
	END FUNCTION;

	-- binary encoding conversion functions
	-- ==========================================================================
	-- One-Hot-Code to Binary-Code
  function onehot2bin(onehot : std_logic_vector) return unsigned is
		variable res : unsigned(log2ceilnz(onehot'high+1)-1 downto 0);
		variable chk : natural;
	begin
		res := (others => '0');
		chk := 0;
		for i in onehot'range loop
			if onehot(i) = '1' then
				res := res or to_unsigned(i, res'length);
				chk := chk + 1;
			end if;
		end loop;
		if SIMULATION and chk /= 1 then
			report "Broken 1-Hot-Code with "&integer'image(chk)&" bits set."
				severity error;
		end if;
		return	res;
	end onehot2bin;

	-- Gray-Code to Binary-Code
	function gray2bin(gray_val : std_logic_vector) return std_logic_vector is
		variable res : std_logic_vector(gray_val'range);
	begin	-- gray2bin
		res(res'left) := gray_val(gray_val'left);
		for i in res'left-1 downto res'right loop
			res(i) := res(i+1) xor gray_val(i);
		end loop;
		return res;
	end gray2bin;
	
	-- Binary-Code to One-Hot-Code
	function bin2onehot(value : std_logic_vector) return std_logic_vector is
		variable result		: std_logic_vector(2**value'length - 1 downto 0);
	begin
		result	:= (others => '0');
		result(2 ** to_integer(unsigned(value))) := '1';
		return result;
	end function;
	
	-- Binary-Code to Gray-Code
	function bin2gray(value : std_logic_vector) return std_logic_vector is
		variable result		: std_logic_vector(value'range);
	begin
		result(result'left)	:= value(value'left);
		for i in (result'left - 1) downto result'right loop
			result(i) := value(i) xor value(i + 1);
		end loop;
		return result;
	end function;

	-- bit searching / bit indices
	-- ==========================================================================
	-- Least-Significant Set Bit (lssb): computes a vector of the same length with at most one bit set at the rightmost '1' found in arg.
	function lssb(arg : std_logic_vector) return std_logic_vector is
    variable  res : std_logic_vector(arg'range);
	begin
		res := arg and std_logic_vector(unsigned(not arg)+1);
    return  res;
	end function;
	
  function lssb(arg : bit_vector) return bit_vector is
    variable  res : bit_vector(arg'range);
  begin
    res := to_bitvector(lssb(to_stdlogicvector(arg)));
    return  res;
  end lssb;

	-- Most-Significant Set Bit (mssb): computes a vector of the same length with at most one bit set at the leftmost '1' found in arg.
	function mssb(arg : std_logic_vector) return std_logic_vector is
	begin
		return	reverse(lssb(reverse(arg)));
	end function;
	
  function mssb(arg : bit_vector) return bit_vector is
  begin
    return  reverse(lssb(reverse(arg)));
  end mssb;

	-- Index of lssb
	function lssb_idx(arg : std_logic_vector) return integer is
	begin
		return  to_integer(onehot2bin(lssb(arg)));
	end function;
	
	function lssb_idx(arg : bit_vector) return integer is
    variable  slv : std_logic_vector(arg'range);
	begin
    slv := to_stdlogicvector(arg);
		return  lssb_idx(slv);
	end lssb_idx;

	-- Index of mssb
	function mssb_idx(arg : std_logic_vector) return integer is
	begin
		return  to_integer(onehot2bin(mssb(arg)));
	end function;
	
	function mssb_idx(arg : bit_vector) return integer is
    variable  slv : std_logic_vector(arg'range);
	begin
    slv := to_stdlogicvector(arg);
		return  mssb_idx(slv);
	end mssb_idx;

	function resize(vec : bit_vector; length : natural; fill : bit := '0') return bit_vector is
    constant  high2b : natural := vec'low+length-1;
		constant  highcp : natural := imin(vec'high, high2b);
    variable  res_up : bit_vector(vec'low to high2b);
    variable  res_dn : bit_vector(high2b downto vec'low);
	begin
    if vec'ascending then
      res_up := (others => fill);
      res_up(vec'low to highcp) := vec(vec'low to highcp);
      return  res_up;
    else
      res_dn := (others => fill);
      res_dn(highcp downto vec'low) := vec(highcp downto vec'low);
      return  res_dn;
		end if;
	end resize;

	function resize(vec : std_logic_vector; length : natural; fill : std_logic := '0') return std_logic_vector is
    constant  high2b : natural := vec'low+length-1;
		constant  highcp : natural := imin(vec'high, high2b);
    variable  res_up : std_logic_vector(vec'low to high2b);
    variable  res_dn : std_logic_vector(high2b downto vec'low);
	begin
    if vec'ascending then
      res_up := (others => fill);
      res_up(vec'low to highcp) := vec(vec'low to highcp);
      return  res_up;
    else
      res_dn := (others => fill);
      res_dn(highcp downto vec'low) := vec(highcp downto vec'low);
      return  res_dn;
		end if;
	end resize;

	-- Move vector boundaries
	-- ==========================================================================
  function move(vec : std_logic_vector; ofs : integer) return std_logic_vector is
    variable res_up : std_logic_vector(vec'low +ofs to     vec'high+ofs);
    variable res_dn : std_logic_vector(vec'high+ofs downto vec'low +ofs);
  begin
    if vec'ascending then
      res_up := vec;
      return  res_up;
    else
      res_dn := vec;
      return  res_dn;
    end if;
  end move;

	function movez(vec : std_logic_vector) return std_logic_vector is
  begin
    return  move(vec, -vec'low);
  end movez;

  function ascend(vec : std_logic_vector)	return std_logic_vector is
		variable  res : std_logic_vector(vec'low to vec'high);
	begin
		res := vec;
		return  res;
	end ascend;

  function descend(vec : std_logic_vector)	return std_logic_vector is
		variable  res : std_logic_vector(vec'high downto vec'low);
	begin
		res := vec;
		return  res;
	end descend;
end utils;
