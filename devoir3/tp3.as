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

		mov		x23, #0					// Initialisation: boucle du principal de 0..80
		mov		x24, #0					// Initialisation: boucle du secondaire de 0..9

VerifierSudoku_BigLoop:
		adr		x19, Sudoku				// Paramètre: adresse du sudoku dans x19
		adr		x20, tab_row			// Paramètre: adresse du tableau des rangés dans x20
		adr		x21, tab_col			// Paramètre: adresse du tableau des colonnes dans x21
		adr		x22, tab_bloc			// Paramètre: adresse du tableau des blocs dans x22

		cmp		x23, #80				// Vérification: Limite de la boucle d'affichage du sudoku
		b.gt	VerifierSudoku_BigLoopEnd // Sortie de la boucle


		mov		x9, #9					// Constante nombre 9
		
		// Initialisation de l'index de tab_col
		mov		x0, x23					// Paramètre d'entrée nombre1 pour VerifierSudoku_modulo  
		mov		x1, x9					// Paramètre d'entrée nombre2 pour VerifierSudoku_modulo
		bl		VerifierSudoku_modulo	// Appelle le sous-programme VerifierSudoku_modulo	x23 % 9
		mov		x25, x0					// Initialiser l'index de tab_col	x25 <= (X)
		mul		x1, x25, x9				// Ajustement de l'alignement de l'index x25 * 9 bits
		add		x11, x21, x1			// Récupérer l'adresse courante de tab_col
		sub		x2, x11, x21			// Récupérer la référence courante de la colonne
		udiv	x2, x2, x9				// Ajuster la référence courante de la colonne / 9 => (0..8)
		add		x2, x2, #1				// Ajuster la référence courante de la colonne + 1 => (1..9)

		// Initialisation l'index de tab_row
		udiv	x26, x23, x9			// Initialiser l'index de tab_row	x26 <= (Y) = x23 / 9
		mul		x1, x26, x9				// Ajustement de l'alignement de l'index x26 * 9 bits
		add		x10, x20, x1			// Récupérer l'adresse courante de tab_row
		sub		x3, x10, x20			// Récupérer la référence courante de la rangé
		udiv	x3, x3, x9				// Ajuster la référence courante de la rangé / 9 => (0..8)
		add		x3, x3, #1				// Ajuster la référence courante de la rangé + 1 => (1..9)
		

		// Initialisation de l'index de tab_bloc (X)
		mov		x0, x25					// Paramètre d'entrée nombre1 pour VerifierSudoku_ceil
		mov		x1, #3					// Paramètre d'entrée nombre2 pour VerifierSudoku_ceil 
		bl		VerifierSudoku_ceil		// Appelle le sous-programme VerifierSudoku_ceil x25 / 3 
		mov		x27, x0					// Initialiser l'index de tab_bloc	x27 <= (X) = x0

		// Initialisation de l'index de tab_bloc (Y)
		mov		x0, x26					// Paramètre d'entrée nombre1 pour VerifierSudoku_ceil
		mov		x1, #3					// Paramètre d'entrée nombre2 pour VerifierSudoku_ceil 
		bl		VerifierSudoku_ceil		// Appelle le sous-programme VerifierSudoku_ceil x25 / 3 
		mul		x1, x0, x1				// Initialiser l'index de tab_bloc	x11 <= (Y)
		add		x1, x27, x1				// Initialiser l'index de tab_bloc	x27 <= (X,Y) = (X-3)+(Y*3)
		mul		x1, x1, x9				// Ajustement de l'alignement de l'index x27 * 9 bits
		add		x12, x22, x1			// Récupérer l'adresse courante de tab_bloc

		sub		x22, x12, x22			// Récupérer la référence courante du bloc
		udiv	x22, x22, x9			// Ajuster la référence courante de la colonne / 9 => (0..8)

		ldrsb	x1, [x19, x23]			// Récupérer la valeur du sudoku à l'index x23


		mov		x13, #0					// Compteur des répétitions (rangé, colonne et bloc)

		mov		x4, #0					// Compteur des répétitions dans rangé
		mov		x5, #0					// Compteur des répétitions dans colonne
		mov		x6, #0					// Compteur des répétitions dans bloc

VerifierSudoku_SmallLoop:

		cmp		x1, #0					// Es-ce que la valeur du sudoku est égale à 0
		b.eq	VerifierSudoku_BigLoopPass // Ne pas faire devérification

		ldrsb	x25, [x10],	#1			// Récupérer l'index de la céllule de la rangé courante (tab_row ++)
		ldrsb	x9, [x19, x25]			// Récupérer la valeur de la céllule du sudoku
		cmp		x9, x1					// Verifier la correspondance des valeurs des cellules
		csinc	x4, x4, x4, ne			// Si n'est pas égale compteur d'erreur par rangé ne change pas, sinon ++
		csinc	x13, x13, x13, ne		// Si n'est pas égale compteur d'erreur total ne change pas, sinon ++

		ldrsb	x26, [x11], #1			// Récupérer l'index de la céllule de la colonne courante (tab_col ++)
		ldrsb	x9, [x19, x26]			// Récupérer la valeur de la céllule du sudoku
		cmp		x9, x1					// Verifier la correspondance des valeurs des cellules
		csinc	x5, x5, x5, ne			// Si n'est pas égale compteur d'erreur par colonne ne change pas, sinon ++
		csinc	x13, x13, x13, ne		// Si n'est pas égale compteur d'erreur total ne change pas, sinon ++

		ldrsb	x27, [x12], #1			// Récupérer l'index de la céllule du bloc courante (tab_col ++)
		ldrsb	x9, [x19, x27]			// Récupérer la valeur de la céllule du sudoku
		cmp		x9, x1					// Verifier la correspondance des valeurs des cellules
		csinc	x6, x6, x6, ne			// Si n'est pas égale compteur d'erreur par bloc ne change pas, sinon ++
		csinc	x13, x13, x13, ne		// Si n'est pas égale compteur d'erreur total ne change pas, sinon ++

VerifierSudoku_SmallLoopEnd:
		
		add		x24, x24, #1			// Incrémenter l'index de la petite boucle (0..9) ++
		cmp		x24, #9					// Vérifier si l'index est égale à 9
		b.lt	VerifierSudoku_SmallLoop // si petite boucle pas fini, aller au début de la boucle
		b.ge	VerifierSudoku_AfficheResult // si petite boucle fini, afficher 

VerifierSudoku_AfficheResult:
		cmp		x13, #3					// Vérifier si il y a d'erreur
		b.le	VerifierSudoku_BigLoopPass // si pas d'erreur aller à la fin de la grande boucle
		adr		x0, ptfmt4				// Paramètre: adresse du message d'erreur
		sub		x4, x4, #1				// Paramètre: référence de la rangé courante
		sub		x5, x5, #1				// Paramètre: référence de la colonne courante
		sub		x6, x6, #1				// Paramètre: référence du bloc courant
		bl		printf					// Afficher le message d'erreur


VerifierSudoku_BigLoopPass:

		mov		x24, #0					// Initialisation: boucle du secondaire de 0..9
		add		x23, x23, #1			// Incrémenter la grande boucle
		b.al	VerifierSudoku_BigLoop	// recommencer la grande boucle

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
VerifierSudoku_ceil:
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
VerifierSudoku_modulo:
		udiv	x2, x0, x1				// x2 = floor(x0/x1)
		mul 	x3, x1, x2				// x3 = x1 * floor(x0/x1)
		sub		x0, x0, x3				// x0 <- x0 - x3 = x0 -(x1 * floor(x0/x1))
		ret

.section ".rodata"

scfmt1:     .asciz  "%d"

ptfmt2:     .asciz	"| %d %d %d "
ptfmt3:     .asciz	"| %d %d %d |\n"
ptfmt4:		.asciz	"\n\nErreur avec le nombre %d aux coordonnées (%d, %d). Les Erreurs sont: \n%d dans la rangé, %d dans la colonne  et %d dans le bloc\n"

.section ".bss"

			.align 1
Sudoku: 	.skip 81
CheckList: 	.skip 9
coord:		.skip 2

.section ".data"

tab_row:	.byte	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80
tab_col:	.byte	0, 9, 18, 27, 36, 45, 54, 63, 72, 1, 10, 19, 28, 37, 46, 55, 64, 73, 2, 11, 20, 29, 38, 47, 56, 65, 74, 3, 12, 21, 30, 39, 48, 57, 66, 75, 4, 13, 22, 31, 40, 49, 58, 67, 76, 5, 14, 23, 32, 41, 50, 59, 68, 77, 6, 15, 24, 33, 42, 51, 60, 69, 78, 7, 16, 25, 34, 43, 52, 61, 70, 79, 8, 17, 26, 35, 44, 53, 62, 71, 80
tab_bloc:	.byte	0, 1, 2, 9, 10, 11, 18, 19, 20, 3, 4, 5, 12, 13, 14, 21, 22, 23, 6, 7, 8, 15, 16, 17, 24, 25, 26, 27, 28, 29, 36, 37, 38, 45, 46, 47, 30, 31, 32, 39, 40, 41, 48, 49, 50, 33, 34, 35, 42, 43, 44, 51, 52, 53, 54, 55, 56, 63, 64, 65, 72, 73, 74, 57, 58, 59, 66, 67, 68, 75, 76, 77, 60, 61, 62, 69, 70, 71, 78, 79, 80
ptfmt1:     .asciz	"|-------|-------|-------|\n"
