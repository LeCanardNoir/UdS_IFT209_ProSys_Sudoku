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
		mov		x20, x0
		add		x19, x20, #80


VerifierSudoku_xy:
VerifierSudoku_x:
VerifierSudoku_y:
VerifierSudoku_sqr:


        RESTORE
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

ptfmt1:     .asciz	"|-------|-------|-------|\n"
