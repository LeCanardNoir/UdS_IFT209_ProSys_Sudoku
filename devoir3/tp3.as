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
		mov		x20, x0				//On met l'adresse de Sudoku dans x20
		adr		x0, ptfmt1
		bl		printf				//On affiche une ligne horizontale

AfficherSudoku_loopInit:
		mov		x19, #0				//On met dans x19 l'index
		mov		x28, #0				//L'index pour les lignes horizontale (chaque modulo 27)
		mov		x27, #0				//L'index pour changer de ligne (chaque modulo 9)
		mov		x26, #0				//L'index pour les barres verticales (chaque modulo 3)
AfficherSudoku_LoopCheck:
		cmp		x19, #81			//Si l'index est plus petit que 81, on continue, sinon, STOP
		b.ge	AfficherSudoku_loopEnd
AfficherSudoku_LoopContent:
		cmp		x28, #27
		csel	x28, xzr, x28, ge
		cmp		x28, #0
		b.eq	AfficherSudoku_SkipLigneHorizontale
		adr		x0, ptfmt1
		bl		printf

AfficherSudoku_SkipLigneHorizontale:
		cmp		x26, #3
		csel	x26, xzr, x26, ge
		cmp		x26, #0
		b.eq	AfficherSudoku_SkipBarreVerticale
		adr		x0, ptfmt3
		bl		printf

AfficherSudoku_SkipBarreVerticale:
		adr		x0, ptfmt2
		adr		x1, [x20], #1
		bl		printf

		cmp		x27, #9
		csel	x27, xzr, x27, ge
		cmp		x27, #0
		b.eq	AfficherSudoku_SkipNouvelleLigne
		adr		x0, ptfmt4
		bl		printf

AfficherSudoku_SkipNouvelleLigne:
		add		x28, x28, #1
		add		x27, x27, #1
		add		x26, x26, #1
		add		x19, x19, #1		//Incrémente l'index
		b.al	AfficherSudoku_LoopCheck

AfficherSudoku_loopEnd:

        RESTORE
		ret


VerifierSudoku:
        SAVE
		mov		x20, x0				//x20 contient l'adresse du sudoku



VerifierSudoku_Rangees:
VerifierSudoku_Rangees_OuterLoopInit:
		mov		x19, #0				//Contient la valeur représentant quelle est la rangée courante
		mov		x28, #0				//Contient index outerloop (ou)
VerifierSudoku_Rangees_OuterLoopCheck:
		cmp		x28, #81
		b.lt	VerifierSudoku_Rangees_OuterLoopContent
		b.al	VerifierSudoku_Rangees_OuterLoopEnd
VerifierSudoku_Rangees_OuterLoopContent:
VerifierSudoku_Rangees_InnerLoopInit:
		mov		x27, #0				//Contient index innerloop (in)
		mov		x26, #0				//Contient le "tableau binaire" de valeurs enregistrées
		mov		x25, #0				//Contient le "tableau binaire" de valeurs dupliquées
VerifierSudoku_Rangees_InnerLoopCheck:
		cmp		x27, #9
		b.lt	VerifierSudoku_Rangees_InnerLoopContent
		b.al	VerifierSudoku_Rangees_InnerLoopEnd
VerifierSudoku_Rangees_InnerLoopContent:
		add		x21, x27, x28		//x21 contient l'index dans le sudoku (ou+in)

		ldrb	w9, [x20, x21]		//x9 contient la valeur à l'emplacement du sudoku
		mov		x10, #1
		lsl		x10, x10, x9		//met (1 << x9) dans x10
		and		x11, x26, x10		//x11 = 0 si x9 n'est pas dupliquée. Sinon, x11 = (1 << x9)
		orr		x25, x25, x11		//On met dans le "tableau binaire" le résultat (si x9 est dupliqué)
		orr		x26, x26, x10		//On ajoute la valeur au "tableau binaire" des valeurs enregistrées

		add		x27, x27, #1
		b.al	VerifierSudoku_Rangees_InnerLoopCheck
VerifierSudoku_Rangees_InnerLoopEnd:

		lsr		x26, x26, #1
		lsl		x26, x26, #1		//On reset le bit 0 du "tableau binaire"
		lsr		x25, x25, #1
		lsl		x25, x25, #1		//On reset le bit 0 du "tableau binaire"

		mov		x0, x25
		mov		x1, x19
		mov		x2, #0
		bl		AfficherMessage_NombreDuplique

		add		x19, x19, #1
		add		x28, x28, #9
		b.al	VerifierSudoku_Rangees_OuterLoopCheck
VerifierSudoku_Rangees_OuterLoopEnd:






VerifierSudoku_Colonnes:
VerifierSudoku_Colonnes_OuterLoopInit:
		mov		x19, #0				//Contient la valeur représentant quelle est la colonne courante
		mov		x28, #0				//Contient index outerloop (ou)
VerifierSudoku_Colonnes_OuterLoopCheck:
		cmp		x28, #9
		b.lt	VerifierSudoku_Colonnes_OuterLoopContent
		b.al	VerifierSudoku_Colonnes_OuterLoopEnd
VerifierSudoku_Colonnes_OuterLoopContent:
VerifierSudoku_Colonnes_InnerLoopInit:
		mov		x27, #0				//Contient index interloop (in)
		mov		x26, #0				//Contient le "tableau binaire" de valeurs enregistrées
		mov		x25, #0				//Contient le "tableau binaire" de valeurs dupliquées
VerifierSudoku_Colonnes_InnerLoopCheck:
		cmp		x27, #81
		b.lt	VerifierSudoku_Colonnes_InnerLoopContent
		b.al	VerifierSudoku_Colonnes_InnerLoopEnd
VerifierSudoku_Colonnes_InnerLoopContent:
		add		x21, x27, x28		//x21 contient l'index dans le sudoku (ou+in)

		ldrb	w9, [x20, x21]		//x9 contient la valeur à l'emplacement du sudoku
		mov		x10, #1
		lsl		x10, x10, x9		//met (1 << x9) dans x10
		and		x11, x26, x10		//x11 = 0 si x9 n'est pas dupliquée. Sinon, x11 = (1 << x9)
		orr		x25, x25, x11		//On met dans le "tableau binaire" le résultat (si x9 est dupliqué)
		orr		x26, x26, x10		//On ajoute la valeur au "tableau binaire" des valeurs enregistrées

		add		x27, x27, #9
		b.al	VerifierSudoku_Colonnes_InnerLoopCheck
VerifierSudoku_Colonnes_InnerLoopEnd:

		lsr		x26, x26, #1
		lsl		x26, x26, #1		//On reset le bit 0 du "tableau binaire"
		lsr		x25, x25, #1
		lsl		x25, x25, #1		//On reset le bit 0 du "tableau binaire"

		mov		x0, x25
		mov		x1, x19
		mov		x2, #0
		bl		AfficherMessage_NombreDuplique

		add		x19, x19, #1
		add		x28, x28, #1
		b.al	VerifierSudoku_Colonnes_OuterLoopCheck
VerifierSudoku_Colonnes_OuterLoopEnd:






VerifierSudoku_Blocs:
VerifierSudoku_Blocs_OuterLoopInit:
		mov		x19, #0				//Contient la valeur représentant quelle est la colonne courante
		mov		x28, #0				//Contient index outerloop (ou)
VerifierSudoku_Blocs_OuterLoopCheck:
		cmp		x28, #81
		b.lt	VerifierSudoku_Blocs_OuterLoopContent
		b.al	VerifierSudoku_Blocs_OuterLoopEnd
VerifierSudoku_Blocs_OuterLoopContent:
VerifierSudoku_Blocs_InnerLoopInit:
		mov		x27, #0				//Contient index innerloop (in)
		mov		x26, #0				//Contient le "tableau binaire" de valeurs enregistrées
		mov		x25, #0				//Contient le "tableau binaire" de valeurs dupliquées
VerifierSudoku_Blocs_InnerLoopCheck:
		cmp		x27, #27
		b.lt	VerifierSudoku_Blocs_InnerLoopContent
		b.al	VerifierSudoku_Blocs_InnerLoopEnd
VerifierSudoku_Blocs_InnerLoopContent:
		add		x21, x27, x28		//x21 contient l'index dans le sudoku (ou+in)


		ldrb	w9, [x20, x21]		//x9 contient la valeur à l'emplacement du sudoku
		mov		x10, #1
		lsl		x10, x10, x9		//met (1 << x9) dans x10
		and		x11, x26, x10		//x11 = 0 si x9 n'est pas dupliquée. Sinon, x11 = (1 << x9)
		orr		x25, x25, x11		//On met dans le "tableau binaire" le résultat (si x9 est dupliqué)
		orr		x26, x26, x10		//On ajoute la valeur au "tableau binaire" des valeurs enregistrées



		mov		x0, x27
		mov		x1, #3
		bl		Fonction_Modulo
		mov		x9, x0				//x9 contient in mod 3
		add		x14, x27, #1		//x14 contient in+1
		add		x15, x27, #7		//x15 contient in+7
		cmp		x9, #2
		csel	x27, x15, x14, eq
		b.al	VerifierSudoku_Blocs_InnerLoopCheck
VerifierSudoku_Blocs_InnerLoopEnd:

		lsr		x26, x26, #1
		lsl		x26, x26, #1		//On reset le bit 0 du "tableau binaire"
		lsr		x25, x25, #1
		lsl		x25, x25, #1		//On reset le bit 0 du "tableau binaire"

		mov		x0, x25
		mov		x1, x19
		mov		x2, #0
		bl		AfficherMessage_NombreDuplique
		add		x19, x19, #1

		mov		x0, x28
		mov		x1, #9
		bl		Fonction_Modulo
		mov		x9, x0
		add		x14, x28, #3
		add		x15, x28, #21
		cmp		x9, #6
		csel	x28, x15, x14, eq
		b.al	VerifierSudoku_Blocs_OuterLOopCheck
VerifierSudoku_Blocs_OuterLoopEnd:
        RESTORE
		ret


/*
	Entrées:
		x0: nombre1
		x1: nombre2
	Sorties:
		x0: nombre1 modulo nombre2
*/
Fonction_Modulo:
		udiv	x2, x0, x1				// x2 = floor(x0/x1)
		mul		x3, x1, x2				// x3 = x1 * floor(x0/x1)
		sub		x0, x0, x3				// x0 <- x0 - x3 = x0 - (x1 * floor(x0/x1)) 
		ret


/*
	Entrées:
		x0: "tableau binaire" des valeurs dupliquées
		x1: numéro de la rangée/colonne/bloc courant
		x2:
			contient 0 si c'est une rangée
			contient 1 si c'est une colonne
			contient 2 si c'est un bloc
	Sorties:
		message dans la console
*/
AfficherMessage_NombreDuplique:

		//TODO


		ret



.section ".rodata"

scfmt1:     .asciz  "%d"
ptfmt1:     .asciz	"|-------|-------|-------|\n"
ptfmt2:		.asciz	"%d "
ptfmt3:		.asciz	"| "
ptfmt4:		.asciz	"|\n"

.section ".bss"

buffer: .skip 4
Sudoku: .skip 81
