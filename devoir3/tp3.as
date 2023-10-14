/********************************************************************************
*																				*
*	Programme qui lit, affiche et vérifie un sudoku.                          	*
*																				*
*															                    *
*	Auteurs: 																	*
*																				*
********************************************************************************/




.include "/root/SOURCES/ift209/tools/ift209.as"



.global Main


.section ".text"

/* Début du programme */

Main:	adr		x20,Sudoku          	// x20 contient l'adresse de base du sudoku

        mov		x0,x20              	// Paramètre: adresse du sudoku
        bl      LireSudoku				// Appelle le sous-programme de lecture

		mov		x0,x20					// Paramètre: adresse du sudoku
		bl		AfficherSudoku			// Appelle le sous-programme d'affichage

		mov		x0,x20					// Paramètre: adresse du sudoku
		bl		VerifierSudoku			// Appelle le sous-programme de vérification

		mov		x0,#0					// 0: tous les tampons
		bl      fflush					// Vidange des tampons

		mov		x0,#0					// 0: aucune erreur
		bl      exit					// Fin du programme




LireSudoku:								// Lire Sudoku
        SAVE
		mov		x19, #0					// Initialisation: boucle de lecture du sudoku
		mov		x20, x0					// Paramètre: adresse du sudoku dans x20

LireSudoku_LoopCheck:
		cmp		x19, #81				// Vérification: Limite de la boucle de lecture du sudoku
		b.ge	LireSudoku_LoopEnd		// Appelle le sous-programme fin de boucle	

		adr		x0, scfmt1				// Paramètre: adresse d'entrée
		add		x1, x20, x19      		// Paramètre: adresse d'écriture
		bl		scanf					// Écriture d'un nombre dans l'adresse Sudoku

		add		x19, x19, #1			// Incrémentation de l'index
		b.al	LireSudoku_LoopCheck	

LireSudoku_LoopEnd:
		RESTORE							
        ret								// Sortie du programme LireSudoku


AfficherSudoku:
        SAVE
		mov		x20, x0					// Paramètre: adresse du sudoku dans x20
		mov		x19, #0					// Initialisation: boucle d'affichage du sudoku
		mov		x21, #3					// Initialisation: boucle d'affichage du séparateur

AfficherSudoku_sep:
		cmp		x21, #3					// Vérification: Limite de la boucle d'affichage du séparateur
		b.lt	AfficherSudoku_Loop		// Appelle le sous-programme boucle d'affichage

		adr		x0, ptfmt1				// Paramètre: adresse d'affichage du séparateur
		ldr		x1, [x0]				// Chargement: contenu d'affichage du séparateur
		bl		printf					// Affichage: séparateur de ligne
		mov		x21, #0					// Initialisation: boucle d'affichage du séparateur
		
AfficherSudoku_Loop:
		cmp		x19, #9					// Vérification: Limite de la boucle d'affichage du sudoku
		b.ge	AfficherSudoku_LoopEnd	// Appelle le sous-programme fin de boucle	

		adr		x0, ptfmt2				// Paramètre: adresse d'affichage début d'une rangé du sudoku
		ldrb	w1, [x20], #1			// Chargement: contenu du sudoku ++
		ldrb	w2, [x20], #1			// Chargement: contenu du sudoku ++
		ldrb	w3, [x20], #1			// Chargement: contenu du sudoku ++
		bl		printf					// Affichage: premier bloc d'une rangé du sudoku

		adr	x0, ptfmt2					// Paramètre: adresse d'affichage d'une rangé du sudoku
		ldrb	w1, [x20], #1			// Chargement: contenu du sudoku ++
		ldrb	w2, [x20], #1			// Chargement: contenu du sudoku ++
		ldrb	w3, [x20], #1			// Chargement: contenu du sudoku ++
		bl		printf					// Affichage: Deuxième bloc d'une rangé du sudoku

		adr		x0, ptfmt3				// Paramètre: adresse d'affichage fin de rangé du sudoku
		ldrb	w1, [x20], #1			// Chargement: contenu du sudoku ++
		ldrb	w2, [x20], #1			// Chargement: contenu du sudoku ++
		ldrb	w3, [x20], #1			// Chargement: contenu du sudoku ++
		bl		printf					// Affichage: Troisième bloc d'une rangé du sudoku

		add		x21, x21, #1			// Incrémentation: boucle d'affichage du séparateur
		add		x19, x19, #1			// Incrémentation: boucle d'affichage du sudoku
		b.al	AfficherSudoku_sep		// Appelle le sous-programme d'affichage du séparateur

AfficherSudoku_LoopEnd:
        RESTORE
		ret


VerifierSudoku:
        SAVE
		mov		x19, x0					// Paramètre: adresse du sudoku dans x19
		adr		x20, tab_row			// Paramètre: adresse du tableau des rangés dans x20
		adr		x21, tab_col			// Paramètre: adresse du tableau des colonnes dans x21
		adr		x22, tab_bloc			// Paramètre: adresse du tableau des blocs dans x22

		mov		x23, #0					// Initialisation: boucle du principal de 0..80
		mov		x24, #0					// Initialisation: boucle du secondaire de 0..9

VerifierSudoku_BigLoop:
		cmp		x23, #80				// Vérification: Limite de la boucle d'affichage du sudoku
		b.gt	VerifierSudoku_BigLoopEnd


		mov		x9, #9
										// Initialisation de l'index de tab_col
		mov		x0, x23					// Paramètre d'entrée nombre1 pour Fonction_modulo  
		mov		x1, x9					// Paramètre d'entrée nombre2 pour Fonction_modulo
		bl		Fonction_modulo			// Appelle le sous-programme Fonction_modulo	x23 % 9
		mov		x25, x0					// Initialiser l'index de tab_col	x25 <= (X)
		mul		x1, x25, x9
		add		x11, x21, x1			// init tab_col value at index x25


		udiv	x26, x23, x9			// Initialiser l'index de tab_row	x26 <= (Y) = x23 / 9
		mul		x1, x26, x9
		add		x10, x20, x1			// init tab_row value at index x26
		

										// Initialisation de l'index de tab_bloc (X)
		mov		x0, x25					// Paramètre d'entrée nombre1 pour Fonction_ceil
		mov		x1, #3					// Paramètre d'entrée nombre2 pour Fonction_ceil 
		bl		Fonction_ceil			// Appelle le sous-programme Fonction_ceil x25 / 3 
		mov		x27, x0					// Initialiser l'index de tab_bloc	x27 <= (X) = x0

										// Initialisation de l'index de tab_bloc (Y)
		mov		x0, x26					// Paramètre d'entrée nombre1 pour Fonction_ceil
		mov		x1, #3					// Paramètre d'entrée nombre2 pour Fonction_ceil 
		bl		Fonction_ceil			// Appelle le sous-programme Fonction_ceil x25 / 3 
		mul		x1, x0, x1				// Initialiser l'index de tab_bloc	x11 <= (Y)
		add		x1, x27, x1				// Initialiser l'index de tab_bloc	x27 <= (X,Y) = (X-3)+(Y*3)
		mul		x1, x1, x9
		add		x12, x22, x1			// init tab_bloc value at index x27


		sub		x1, x10, x20			// tab_row[x] address at x10 - x20
		sub		x2, x11, x21			// tab_col[x] address at x10 - x20
		sub		x3, x12, x22			// tab_bloc[x] address at x10 - x20

VerifierSudoku_SmallLoop:

		ldrb	w25, [x10],	#1			// load tab_row  value ++
		ldrb	w26, [x11], #1			// load tab_col value ++
		ldrb	w27, [x12], #1			// load tab_bloc value ++
		
		add		x24, x24, #1
		cmp		x24, #9
		b.lt	VerifierSudoku_SmallLoop

		mov		x24, #0					// Initialisation: boucle du secondaire de 0..9
		add		x23, x23, #1
		b.al	VerifierSudoku_BigLoop

VerifierSudoku_BigLoopEnd:

        RESTORE
		ret

/*
Entrées:
	x0: nombre1
	x1: nombre2
Sortie:
	x0: (nombre1 / nombre2) arrondi à la hausse
*/
Fonction_ceil:
		neg		x0, x0
		sdiv	x0, x0, x1
		neg		x0, x0
		ret

/*
Entrées:
	x0: nombre1
	x1: nombre2
Sortie:
	x0: nombre1 modulo nombre2
*/
Fonction_modulo:
		udiv	x2, x0, x1				// x2 = floor(x0/x1)
		mul 	x3, x1, x2				// x3 = x1 * floor(x0/x1)
		sub		x0, x0, x3				// x0 <- x0 - x3 = x0 -(x1 * floor(x0/x1))
		ret


.section ".rodata"

scfmt1:     .asciz  "%d"

ptfmt2:     .asciz	"| %d %d %d "
ptfmt3:     .asciz	"| %d %d %d |\n"

.section ".bss"

			.align 1
Sudoku: 	.skip 81
CheckList: 	.skip 9
coord:		.skip 2

.section ".data"

tab_row:	.byte	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80
tab_col:	.byte	0, 9, 18, 27, 36, 45, 54, 63, 72, 1, 10, 19, 28, 37, 46, 55, 66, 73, 2, 11, 20, 29, 38, 47, 56, 65, 74, 3, 12, 21, 30, 39, 48, 57, 66, 75, 4, 13, 22, 31, 40, 49, 58, 67, 76, 5, 14, 23, 32, 41, 50, 59, 68, 77, 6, 15, 24, 33, 42, 51, 60, 69, 78, 7, 16, 25, 34, 43, 52, 61, 70, 79, 8, 17, 26, 35, 44, 53, 62, 71, 80
tab_bloc:	.byte	0, 1, 2, 9, 10, 11, 18, 19, 20, 3, 4, 5, 12, 13, 14, 21, 22, 23, 6, 7, 8, 15, 16, 17, 24, 25, 26, 27, 28, 29, 36, 37, 38, 45, 46, 47, 30, 31, 32, 39, 40, 41, 48, 49, 50, 33, 34, 35, 42, 43, 44, 51, 52, 53, 54, 55, 56, 63, 64, 65, 72, 73, 74, 57, 58, 59, 66, 67, 68, 75, 76, 77, 60, 61, 62, 69, 70, 71, 78, 79, 80
ptfmt1:     .asciz	"|-------|-------|-------|\n"
