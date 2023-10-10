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

Main:	adr		x20,Sudoku          //x20 contient l'adresse de base du sudoku

        mov		x0,x20              //Paramètre: adresse du sudoku
        bl      LireSudoku			//Appelle le sous-programme de lecture

		mov		x0,x20				//Paramètre: adresse du sudoku
		bl		AfficherSudoku		//Appelle le sous-programme d'affichage

		mov		x0,x20				//Paramètre: adresse du sudoku
		bl		VerifierSudoku		//Appelle le sous-programme de vérification

		mov		  x0,#0				//0: tous les tampons
		bl        fflush			//Vidange des tampons

		mov		  x0,#0				//0: aucune erreur
		bl        exit				//Fin du programme




LireSudoku:
        SAVE

		mov		x19, #0
LireSudoku_LoopCheck:
		cmp		x19, #81
		b.ge	LireSudoku_LoopEnd
		add		x19, x19, #1		//Incrémente l'index

		mov		x20, x0				//On met l'adresse du sudoku dans x20
		adr		x21, buffer			//On met l'adresse du buffer dans x21

		adr		x0, scfmt1
		mov		x1, x21
		bl		scanf
		ldr		w22, [x21]			//On met la valeur lue dans x22
        strb	w22, [x20], #1		//On le met dans le sudoku et on déplace l'adresse du sudoku au prochain
LireSudoku_LoopEnd:



		RESTORE
        ret


AfficherSudoku:
        SAVE




        RESTORE
		ret


VerifierSudoku:
        SAVE




        RESTORE
		ret


.section ".rodata"

scfmt1:     .asciz  "%d"
ptfmt1:     .asciz	"|---|---|---|\n"

.section ".bss"

buffer: .skip 4
Sudoku: .skip 81
