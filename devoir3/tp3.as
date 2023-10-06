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

Sudoku: .skip 81
