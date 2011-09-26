package edu.pitt.math.jhol.ssreflect.parser;

/**
 * Token type
 */
enum TokenType {
	EOF,
	STRING, IDENTIFIER, INTEGER,
	LPAR, RPAR,	LBRACK, RBRACK, LBRACE, RBRACE,
	COMMA, COLON, SEMICOLON, ARROW, STAR, BACK_QUOTE, SLASH, DASH, ASSIGN, BAR,
	TRIV, SIMP, TRIV_SIMP, UNDERSCORE, PERIOD, AT, EXCLAMATION, QUESTION,
	LEFT_ARROW, RIGHT_ARROW
}
