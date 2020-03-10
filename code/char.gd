extends Node

# Initialize the characters with dictionaries.
var nine11 = {'video': ['res://images/characters/9-11/911_boi.ogv', 'res://images/characters/9-11/911_concern.ogv', 'res://images/characters/9-11/911_pewpew.ogv', 'res://images/characters/9-11/911_standin.ogv'], 'body': ['res://images/characters/9-11/911_boi.png', 'res://images/characters/9-11/911_concern.png', 'res://images/characters/9-11/911_pewpew.png', 'res://images/characters/9-11/911_standin.png']}

var ephraim = {'body': ['res://images/characters/Cop Killers/ephraim_base.png', 'res://images/characters/Cop Killers/ephraim_dab.png']}
var k1p = {'body': ['res://images/characters/Cop Killers/k1p_base.png', 'res://images/characters/Cop Killers/k1p_dab.png'], "blank": ["res://images/blank.png"]}
var magicks = {'body': ['res://images/characters/Cop Killers/magicks_base.png', 'res://images/characters/Cop Killers/magicks_dab.png'], "blank": ["res://images/blank.png"]}
var schrafft = {'body': ['res://images/characters/Cop Killers/schrafft_base.png', 'res://images/characters/Cop Killers/schrafft_dab.png'], "blank": ["res://images/blank.png"]}
var smearg = {'body': ['res://images/characters/Cop Killers/smearg_base.png', 'res://images/characters/Cop Killers/smearg_dab.png'], "blank": ["res://images/blank.png"]}
var copkillers = { 'body': ['res://images/characters/Cop Killers/killers1.png', 'res://images/characters/Cop Killers/Killerscloud.png', 'res://images/characters/Cop Killers/killersdab1.png', 'res://images/characters/Cop Killers/killersdabcloud.png']}

var kazee = {'face': ['res://images/characters/Kazee/face/kazee_face.png'], 'body': ['res://images/characters/Kazee/kazee_1.png', 'res://images/characters/Kazee/kazee_2.png', 'res://images/characters/Kazee/kazee_3.png']}
var may = {'face': ['res://images/characters/May/faces/may_face_1.png', 'res://images/characters/May/faces/may_face_2.png', 'res://images/characters/May/faces/may_face_3.png', 'res://images/characters/May/faces/may_face_4.png', 'res://images/characters/May/faces/may_face_5.png'], 'body': ['res://images/characters/May/may_1.png', 'res://images/characters/May/may_2.png', 'res://images/characters/May/may_3.png']}
var michelle = {'face': ['res://images/characters/Michelle/faces/michelle_face_1.png', 'res://images/characters/Michelle/faces/michelle_face_2.png', 'res://images/characters/Michelle/faces/michelle_face_3.png', 'res://images/characters/Michelle/faces/michelle_face_4.png', 'res://images/characters/Michelle/faces/michelle_face_5.png'], 'body': ['res://images/characters/Michelle/michelle_1.png', 'res://images/characters/Michelle/michelle_2.png', 'res://images/characters/Michelle/michelle_3.png']}

var actiongiraffe = {'happy': ['res://images/characters/Action Giraffe/faces/ag_face_happy.png'], 'angry': ['res://images/characters/Action Giraffe/faces/ag_face_angry.png'], 'confused': ['res://images/characters/Action Giraffe/faces/ag_face_confused.png'], 'neutral': ['res://images/characters/Action Giraffe/faces/ag_face_neutral.png'], 'sad': ['res://images/characters/Action Giraffe/faces/ag_face_sad.png'], 'shock': ['res://images/characters/Action Giraffe/faces/ag_face_shock.png'], 'blush': ['res://images/characters/Action Giraffe/AFL/ag_face_blushies.png'], 'body': ['res://images/characters/Action Giraffe/ag_gesture1.png', 'res://images/characters/Action Giraffe/ag_gesture2.png', 'res://images/characters/Action Giraffe/ag_gesture3.png']}
var digi = {
	"campus": {
		"happy": [
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_happy1.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_happy2.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_happy3.png"
		],
		"angry": [
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_angry1.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_angry2.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_angry3.png"
		],
		"confused": [
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_confused1.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_confused2.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_confused3.png"
		],
		"neutral": [
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_neutral.png"
		],
		"sad": [
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_sad1.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_sad2.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_sad3.png"
		],
		"shock": [
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_shock1.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_shock2.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_shock3.png"
		],
		"smitten": [
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_blush1.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_blush2.png",
			"res://images/characters/Digibro/Faces_Campus/digi_face_campus_blush3.png"
		],
		"blush": [
			"res://images/characters/Digibro/AFL/digi_face_campus_blushies.png"
		],
		"body": [
			"res://images/characters/Digibro/digi_campus1.png",
			"res://images/characters/Digibro/digi_campus2.png",
			"res://images/characters/Digibro/digi_campus3.png",
			"res://images/characters/Digibro/digi_campus4.png",
			"res://images/characters/Digibro/digi_campus5.png"
		]
	},
	"casual": {
		"happy": [
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_happy1.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_happy2.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_happy3.png"
		],
		"angry": [
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_angry1.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_angry2.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_angry3.png"
		],
		"confused": [
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_confused1.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_confused2.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_confused3.png"
		],
		"neutral": [
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_neutral.png"
		],
		"sad": [
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_sad1.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_sad2.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_sad3.png"
		],
		"shock": [
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_shock1.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_shock2.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_shock3.png"
		],
		"smitten": [
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_blush1.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_blush2.png",
			"res://images/characters/Digibro/Faces_Casual/digi_face_casual_blush3.png"
		],
		"blush": [
			"res://images/characters/Digibro/AFL/digi_face_casual_blushies.png"
		],
		"body": [
			"res://images/characters/Digibro/digi_casual1.png",
			"res://images/characters/Digibro/digi_casual2.png",
			"res://images/characters/Digibro/digi_casual3.png",
			"res://images/characters/Digibro/digi_casual4.png",
			"res://images/characters/Digibro/digi_casual5.png",
			"res://images/characters/Digibro/digi_crouch.png"
		]
	},
	"special": {
		"gendoglint": [
			"res://images/characters/Digibro/Faces_Special/digi_face_special_gendoglint.png"
		],
		"happy": [
			"res://images/characters/Digibro/Faces_Special/digi_face_special_happyMIN.png",
			"res://images/characters/Digibro/Faces_Special/digi_face_special_happyMAX.png"
		],
		"angry": [
			"res://images/characters/Digibro/Faces_Special/digi_face_special_angryMIN.png",
			"res://images/characters/Digibro/Faces_Special/digi_face_special_angryMAX.png"
		],
		"confused": [
			"res://images/characters/Digibro/Faces_Special/digi_face_special_confusedMIN.png",
			"res://images/characters/Digibro/Faces_Special/digi_face_special_confusedMAX.png"
		],
		"neutral": [
			"res://images/characters/Digibro/Faces_Special/digi_face_special_neutral.png"
		],
		"smitten": [
			"res://images/characters/Digibro/Faces_Special/digi_face_special_smittenMIN.png",
			"res://images/characters/Digibro/Faces_Special/digi_face_special_smittenMAX.png"
		],
		"blush": [
			"res://images/characters/Digibro/AFL/digi_face_special_blushiesMIN.png",
			"res://images/characters/Digibro/AFL/digi_face_special_blushiesMAX.png"
		],
		"body": [
			"res://images/characters/Digibro/digi_special1.ogv",
			"res://images/characters/Digibro/digi_special2.ogv",
			"res://images/characters/Digibro/digi_special3.ogv",
			"res://images/characters/Digibro/digi_special4.ogv"
		],
		"mask": [
			"res://images/characters/Digibro/digi_special1_mask.png",
			"res://images/characters/Digibro/digi_special2_mask.png",
			"res://images/characters/Digibro/digi_special3_mask.png",
			"res://images/characters/Digibro/digi_special4_mask.png"
		]
	}
}

var artsofartso = {
	"special": {
		"gendoglint": [
			"res://images/characters/ArtsoFartso/Faces_Special/artsofartso_face_special_gendoglint.png"
		],
		"happy": [
			"res://images/characters/ArtsoFartso/Faces_Special/artsofartso_face_special_happyMIN.png",
			"res://images/characters/ArtsoFartso/Faces_Special/artsofartso_face_special_happyMAX.png"
		],
		"angry": [
			"res://images/characters/ArtsoFartso/Faces_Special/artsofartso_face_special_angryMIN.png",
			"res://images/characters/ArtsoFartso/Faces_Special/artsofartso_face_special_angryMAX.png"
		],
		"confused": [
			"res://images/characters/ArtsoFartso/Faces_Special/artsofartso_face_special_confusedMIN.png",
			"res://images/characters/ArtsoFartso/Faces_Special/artsofartso_face_special_confusedMAX.png"
		],
		"neutral": [
			"res://images/characters/ArtsoFartso/Faces_Special/artsofartso_face_special_neutral.png"
		],
		"smitten": [
			"res://images/characters/ArtsoFartso/Faces_Special/artsofartso_face_special_smittenMIN.png",
			"res://images/characters/ArtsoFartso/Faces_Special/artsofartso_face_special_smittenMAX.png"
		],
		"blush": [
			"res://images/characters/ArtsoFartso/AFL/artsofartso_face_special_blushiesMIN.png",
			"res://images/characters/ArtsoFartso/AFL/artsofartso_face_special_blushiesMAX.png"
		],
		"body": [
			"res://images/characters/ArtsoFartso/artsofartso_special1.ogv",
			"res://images/characters/ArtsoFartso/artsofartso_special2.ogv",
			"res://images/characters/ArtsoFartso/artsofartso_special3.ogv",
			"res://images/characters/ArtsoFartso/artsofartso_special4.ogv"
		],
		"mask": [
			"res://images/characters/ArtsoFartso/artsofartso_special1_mask.png",
			"res://images/characters/ArtsoFartso/artsofartso_special2_mask.png",
			"res://images/characters/ArtsoFartso/artsofartso_special3_mask.png",
			"res://images/characters/ArtsoFartso/artsofartso_special4_mask.png"
		]
	}
}

var adelram = { 'blush': ['res://images/characters/Adelram/afl/adelram_face_blush.png'], 'body': ['res://images/characters/Adelram/adelram.png'], 'face': ['res://images/characters/Adelram/face/adelram_face_1.png', 'res://images/characters/Adelram/face/adelram_face_2.png']}
var azumi = {'campus': {'happy': ['res://images/characters/Azumi/face/azumi_face_happyMIN.png', 'res://images/characters/Azumi/face/azumi_face_happyMAX.png'], 'angry': ['res://images/characters/Azumi/face/azumi_face_angryMIN.png', 'res://images/characters/Azumi/face/azumi_face_angryMAX.png'], 'confused': ['res://images/characters/Azumi/face/azumi_face_confusedMIN.png', 'res://images/characters/Azumi/face/azumi_face_confusedMAX.png'], 'neutral': ['res://images/characters/Azumi/face/azumi_face_neutral.png'], 'sad': ['res://images/characters/Azumi/face/azumi_face_sadMIN.png', 'res://images/characters/Azumi/face/azumi_face_sadMAX.png'], 'shock': ['res://images/characters/Azumi/face/azumi_face_shockMIN.png', 'res://images/characters/Azumi/face/azumi_face_shockMAX.png'], 'smitten': ['res://images/characters/Azumi/face/azumi_face_smittenMIN.png', 'res://images/characters/Azumi/face/azumi_face_smittenMAX.png'], 'blush': ['res://images/characters/Azumi/afl/azumi_face_angryMAX_blushMIN.png', 'res://images/characters/Azumi/afl/azumi_face_angryMAX_blushMAX.png', 'res://images/characters/Azumi/afl/azumi_face_confusedMAX_blushMIN.png', 'res://images/characters/Azumi/afl/azumi_face_confusedMAX_blushMAX.png', 'res://images/characters/Azumi/afl/azumi_face_happyMAX_blushMIN.png', 'res://images/characters/Azumi/afl/azumi_face_happyMAX_blushMAX.png', 'res://images/characters/Azumi/afl/azumi_face_neutral_blushMIN.png', 'res://images/characters/Azumi/afl/azumi_face_neutral_blushMAX.png', 'res://images/characters/Azumi/afl/azumi_face_sadMAX_blushMIN.png', 'res://images/characters/Azumi/afl/azumi_face_sadMAX_blushMAX.png', 'res://images/characters/Azumi/afl/azumi_face_shockMAX_blushMIN.png' ,'res://images/characters/Azumi/afl/azumi_face_shockMAX_blushMAX.png', 'res://images/characters/Azumi/afl/azumi_face_smittenMAX_blushMIN.png', 'res://images/characters/Azumi/afl/azumi_face_smittenMAX_blushMAX.png'], 'body': ['res://images/characters/Azumi/azumi_campus.png']}, 'casual': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': [], 'body': ['res://images/characters/Azumi/azumi_casual.png']}}
var brunswick = {'confused': ['res://images/characters/Brunswick/faces/brunswick_face_confused.png'], 'neutral': ['res://images/characters/Brunswick/faces/brunswick_face_neutral.png'], 'worried': ['res://images/characters/Brunswick/faces/brunswick_face_worried.png'], 'body': ['res://images/characters/Brunswick/brunswick.png']}
var cerise = {'happy': ['res://images/characters/Cerise/faces/cerise_face_happy.png'], 'serious': ['res://images/characters/Cerise/faces/cerise_face_serious.png'], 'body': ['res://images/characters/Cerise/cerise.png']}
var coltcorona = {'cani': {'angry': ['res://images/characters/Colt Corona/faces/coltcorona_face1_angryMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face1_angryMED.png', 'res://images/characters/Colt Corona/faces/coltcorona_face1_angryMAX.png'], 'confused': ['res://images/characters/Colt Corona/faces/coltcorona_face1_confusedMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face1_confusedMED.png', 'res://images/characters/Colt Corona/faces/coltcorona_face1_confusedMAX.png'], 'happy': ['res://images/characters/Colt Corona/faces/coltcorona_face1_happyMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face1_happyMED.png', 'res://images/characters/Colt Corona/faces/coltcorona_face1_happyMAX.png'], 'neutral': ['res://images/characters/Colt Corona/faces/coltcorona_face1_neutral.png'], 'sad': ['res://images/characters/Colt Corona/faces/coltcorona_face1_sadMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face1_sadMED.png', 'res://images/characters/Colt Corona/faces/coltcorona_face1_sadMAX.png'], 'shock': ['res://images/characters/Colt Corona/faces/coltcorona_face1_shockMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face1_shockMED.png', 'res://images/characters/Colt Corona/faces/coltcorona_face1_shockMAX.png'], 'smitten': ['res://images/characters/Colt Corona/faces/coltcorona_face1_smittenMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face1_smittenMAX.png'], 'blush': ['res://images/characters/Colt Corona/afls/coltcorona_face1_angryMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face1_confusedMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face1_happyMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face1_neutral_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face1_sadMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face1_shockedMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face1_smittenMAX_blush.png'], 'body': ['res://images/characters/Colt Corona/coltcorona_1_cani.png']}, 'feetguitar': {'angry': ['res://images/characters/Colt Corona/faces/coltcorona_face3_angryMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face3_angryMAX.png'], 'confused': ['res://images/characters/Colt Corona/faces/coltcorona_face3_confusedMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face3_confusedMAX.png'], 'happy': ['res://images/characters/Colt Corona/faces/coltcorona_face3_happyMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face3_happyMAX.png'], 'neutral': ['res://images/characters/Colt Corona/faces/coltcorona_face3_neutral.png'], 'sad': ['res://images/characters/Colt Corona/faces/coltcorona_face3_sadMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face3_sadMAX.png'], 'shock': ['res://images/characters/Colt Corona/faces/coltcorona_face3_shockMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face3_shockMAX.png'], 'smitten': ['res://images/characters/Colt Corona/faces/coltcorona_face3_smittenMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face3_smittenMAX.png'], 'blush': ['res://images/characters/Colt Corona/afls/coltcorona_face3_angryMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face3_confusedMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face3_happyMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face3_neutral_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face3_sadMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face3_shockedMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face3_smittenMAX_blush.png'], 'body': ['res://images/characters/Colt Corona/coltcorona_2_feetguitar.png']}, 'gun': {'angry': [], 'confused': [], 'happy': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': [], 'body': ['res://images/characters/Colt Corona/coltcorona_2_gun.png']}, 'thisvideo': {'angry': [], 'confused': [], 'happy': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': [], 'body': ['res://images/characters/Colt Corona/coltcorona_2_thisvideo.png']}, 'bein': {'angry': ['res://images/characters/Colt Corona/faces/coltcorona_face2_angryMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face2_angryMAX.png'], 'confused': ['res://images/characters/Colt Corona/faces/coltcorona_face2_confusedMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face2_confusedMAX.png'], 'happy': ['res://images/characters/Colt Corona/faces/coltcorona_face2_happyMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face2_happyMAX.png'], 'neutral': ['res://images/characters/Colt Corona/faces/coltcorona_face2_neutral.png'], 'sad': ['res://images/characters/Colt Corona/faces/coltcorona_face2_sadMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face2_sadMAX.png'], 'shock': ['res://images/characters/Colt Corona/faces/coltcorona_face2_shockMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face2_shockMAX.png'], 'smitten': ['res://images/characters/Colt Corona/faces/coltcorona_face2_smittenMIN.png', 'res://images/characters/Colt Corona/faces/coltcorona_face2_smittenMAX.png'], 'blush': ['res://images/characters/Colt Corona/afls/coltcorona_face2_angryMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face2_confusedMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face2_happyMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face2_neutral_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face2_sadMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face2_shockedMAX_blush.png', 'res://images/characters/Colt Corona/afls/coltcorona_face2_smittenMAX_blush.png'], 'body': ['res://images/characters/Colt Corona/coltcorona_3_bein.png']}}
var connor = {'body': ['res://images/characters/Connor/connor_happy.png', 'res://images/characters/Connor/connor_angry.png', 'res://images/characters/Connor/connor_disappointed.png', 'res://images/characters/Connor/connor_neutral.png'], "blank": ["res://images/blank.png"]} 
var crocs = {'body': ['res://images/characters/Crocs/crocs_happy.png', 'res://images/characters/Crocs/crocs_angry.png', 'res://images/characters/Crocs/crocs_neutral.png', 'res://images/characters/Crocs/crocs_disappointed.png', 'res://images/characters/Crocs/Crocs_special_outfit.png'], "blank": ["res://images/blank.png"]} 

var drugdealer = {'body': ['res://images/characters/Drug dealer/drugdealer_angry.png', 'res://images/characters/Drug dealer/drugdealer_neutral.png']}
var geoff = {'body': ['res://images/characters/Geoff/geoff_dead.png', 'res://images/characters/Geoff/geoff_default.png', 'res://images/characters/Geoff/geoff_face_smug.png'], 'angry': ['res://images/characters/Geoff/geoff_face_angry.png'], 'happy': ['res://images/characters/Geoff/geoff_face_happy.png'], 'kawaii': ['res://images/characters/Geoff/geoff_face_kawaii.png'], 'kawaii_sad': ['res://images/characters/Geoff/geoff_face_kawaii_sad.png'], 'neutral': ['res://images/characters/Geoff/geoff_face_neutral.png'], 'sad': ['res://images/characters/Geoff/geoff_face_sad.png'], 'shock': ['res://images/characters/Geoff/geoff_face_shock.png'], 'smug': ['res://images/characters/Geoff/geoff_face_smug2.png']}
var gungirl = {'body': ['res://images/characters/Gungirl/gungirl_1.png', 'res://images/characters/Gungirl/gungirl_2.png', 'res://images/characters/Gungirl/gungirl_3.png', 'res://images/characters/Gungirl/gungirl_4.png', 'res://images/characters/Gungirl/gungirl_5.png', 'res://images/characters/Gungirl/gungirl_6.png', 'res://images/characters/Gungirl/gungirl_7.png', 'res://images/characters/Gungirl/gungirl_8.png', 'res://images/characters/Gungirl/gungirl_9.png']}
var lethal = {'body': ['res://images/characters/Lethal/lethal_1.png', 'res://images/characters/Lethal/lethal_2.png', 'res://images/characters/Lethal/lethal_3.png', 'res://images/characters/Lethal/lethal_4.png', 'res://images/characters/Lethal/lethal_5.png', 'res://images/characters/Lethal/lethal_silouette.png'], 'angry': ['res://images/characters/Lethal/lethal_face_angryMIN.png', 'res://images/characters/Lethal/lethal_face_angryMAX.png'], 'crazy': ['res://images/characters/Lethal/lethal_face_crazyMIN.png', 'res://images/characters/Lethal/lethal_face_crazyMAX.png'], 'happy': ['res://images/characters/Lethal/lethal_face_happyMIN.png', 'res://images/characters/Lethal/lethal_face_happyMAX.png'], 'lewd': ['res://images/characters/Lethal/lethal_face_lewdMIN.png', 'res://images/characters/Lethal/lethal_face_lewdMAX.png'], 'smug': ['res://images/characters/Lethal/lethal_face_smugMIN.png', 'res://images/characters/Lethal/lethal_face_smugMAX.png']}
var lordofghosts = {'body': ['res://images/characters/Lord of Ghosts/lordofghosts_angry.png', 'res://images/characters/Lord of Ghosts/lordofghosts_blush1.png', 'res://images/characters/Lord of Ghosts/lordofghosts_blush2.png', 'res://images/characters/Lord of Ghosts/lordofghosts_blush3.png', 'res://images/characters/Lord of Ghosts/lordofghosts_confuse.png', 'res://images/characters/Lord of Ghosts/lordofghosts_happy.png', 'res://images/characters/Lord of Ghosts/lordofghosts_neutral.png', 'res://images/characters/Lord of Ghosts/lordofghosts_sad.png', 'res://images/characters/Lord of Ghosts/lordofghosts_shock.png']}
var magda = {'body': ['res://images/characters/Magda/magda_neutral.png', 'res://images/characters/Magda/magda_worried.png'], "blank": ["res://images/blank.png"]}
var mumkeyjones = {'body': ['res://images/characters/Mumkey Jones/mumkey.png']}
var pcpguy = {'body': ['res://images/characters/PCPG/pcpg_1.png', 'res://images/characters/PCPG/pcpg_2.png']}
var redman = {'body': ['res://images/characters/Redman/angry.png', 'res://images/characters/Redman/confuse.png', 'res://images/characters/Redman/happy.png', 'res://images/characters/Redman/normal.png', 'res://images/characters/Redman/sad.png', 'res://images/characters/Redman/shock.png', 'res://images/characters/Redman/smittenMIN.png', 'res://images/characters/Redman/smittenMED.png', 'res://images/characters/Redman/smittenMAX.png']}
var russel = {'base': {'body': ['res://images/characters/Russel/russel_base.png'], 'neutral': ['res://images/characters/Russel/russel_face_base_neutral.png'], 'worried': ['res://images/characters/Russel/russel_face_base_worried.png']}, 'bigboi': {'body': ['res://images/characters/Russel/russel_bigboi.png'], 'neutral': ['res://images/characters/Russel/russel_face_bigboi_neutral.png'], 'worried': ['res://images/characters/Russel/russel_face_bigboi_worried.png']}}
var snob = {'body': ['res://images/characters/Snob/snob.png'],'neutral': ['res://images/characters/Snob/snob_face_neutral.png'], 'scared': ['res://images/characters/Snob/snob_face_scared.png'], 'smug': ['res://images/characters/Snob/snob_face_smug.png']}
var sophia = {'body': ['res://images/characters/Sophia/sophia.png'], 'angry': ['res://images/characters/Sophia/sophia_face_angry.png'], 'confused': ['res://images/characters/Sophia/sophia_face_confused.png'], 'happy': ['res://images/characters/Sophia/sophia_face_happy.png'], 'neutral': ['res://images/characters/Sophia/sophia_face_neutral.png'], 'sad': ['res://images/characters/Sophia/sophia_face_sad.png'], 'shock': ['res://images/characters/Sophia/sophia_face_shock.png'], 'smitten': ['res://images/characters/Sophia/sophia_face_smitten.png']}
var hussiefox = {'body': ['res://images/characters/Toby Lee O_Hussiefox/hussiefox.png']}
var v = {'body': ['res://images/characters/V/v_1.png', 'res://images/characters/V/v_2.png', 'res://images/characters/V/v_3.png'], 'angry': ['res://images/characters/V/face/v_face_angry.png'], 'confused': ['res://images/characters/V/face/v_face_confused.png'], 'happy': ['res://images/characters/V/face/v_face_happy.png'], 'neutral': ['res://images/characters/V/face/v_face_neutral.png'], 'sad': ['res://images/characters/V/face/v_face_sad.png'], 'shock': ['res://images/characters/V/face/v_face_shock.png'], 'smitten': ['res://images/characters/V/face/v_face_smitten.png'], 'blush': ['res://images/characters/V/AFL/v_face_blush.png']}
var vincent = {'body': ['res://images/characters/Vincent/vincent.png'], 'angry': ['res://images/characters/Vincent/vincent_face_angry.png'], 'confused': ['res://images/characters/Vincent/vincent_face_confused.png'], 'happy': ['res://images/characters/Vincent/vincent_face_happy.png'], 'neutral': ['res://images/characters/Vincent/vincent_face_neutral.png'], 'sad': ['res://images/characters/Vincent/vincent_face_sad.png'], 'shock': ['res://images/characters/Vincent/vincent_face_shock.png'], 'smitten': ['res://images/characters/Vincent/vincent_face_smitten.png']}

var clara = {'body': ['res://images/characters/Clara/clara.png']}
var maygib = {'body': ['res://images/characters/MayGib/maygib.png']}
var thoth = {'body': ['res://images/characters/Thoth/thoth.png']}

var gibbon = {'campus': {
'happy': ['res://images/characters/Gibbon/Faces/gibbon_face_happy1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_happy2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_happy3.png'],
 'angry': ['res://images/characters/Gibbon/Faces/gibbon_face_angry1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_angry2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_angry3.png'],
 'confused': ['res://images/characters/Gibbon/Faces/gibbon_face_confused1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_confused2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_confused3.png'], 
'neutral': ['res://images/characters/Gibbon/Faces/gibbon_face_neutral.png'],
 'sad': ['res://images/characters/Gibbon/Faces/gibbon_face_sad1.png','res://images/characters/Gibbon/Faces/gibbon_face_sad2.png','res://images/characters/Gibbon/Faces/gibbon_face_sad3.png'],
 'shock': ['res://images/characters/Gibbon/Faces/gibbon_face_shocked1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_shocked2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_shocked3.png'], 
'smitten': ['res://images/characters/Gibbon/Faces/gibbon_face_smitten1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_smitten2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_smitten3.png'], 
'blush': ['res://images/characters/Gibbon/AFL/gibbon_face_blushies.png'], 
'body': ['res://images/characters/Gibbon/gibbon_campus1_default.png', 'res://images/characters/Gibbon/gibbon_campus2_clenched.png', 'res://images/characters/Gibbon/gibbon_campus3_grabby.png', 'res://images/characters/Gibbon/gibbon_campus4_handsup.png', 'res://images/characters/Gibbon/gibbon_campus5_press.png']}, 
'casual': {

'happy': ['res://images/characters/Gibbon/Faces/gibbon_face_happy1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_happy2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_happy3.png'],
 'angry': ['res://images/characters/Gibbon/Faces/gibbon_face_angry1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_angry2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_angry3.png'],
 'confused': ['res://images/characters/Gibbon/Faces/gibbon_face_confused1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_confused2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_confused3.png'], 
'neutral': ['res://images/characters/Gibbon/Faces/gibbon_face_neutral.png'],
 'sad': ['res://images/characters/Gibbon/Faces/gibbon_face_sad1.png','res://images/characters/Gibbon/Faces/gibbon_face_sad2.png','res://images/characters/Gibbon/Faces/gibbon_face_sad3.png'],
 'shock': ['res://images/characters/Gibbon/Faces/gibbon_face_shocked1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_shocked2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_shocked3.png'], 
'smitten': ['res://images/characters/Gibbon/Faces/gibbon_face_smitten1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_smitten2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_smitten3.png'], 
'blush': ['res://images/characters/Gibbon/AFL/gibbon_face_blushies.png'], 
		 'body': ['res://images/characters/Gibbon/gibbon_casual1_default.png', 'res://images/characters/Gibbon/gibbon_casual2_clenched.png', 'res://images/characters/Gibbon/gibbon_casual3_grabby.png', 'res://images/characters/Gibbon/gibbon_casual4_handsup.png', 'res://images/characters/Gibbon/gibbon_casual5_press.png']},

'special':{
	'happy': ['res://images/characters/Gibbon/Faces/gibbon_face_happy1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_happy2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_happy3.png'],
 'angry': ['res://images/characters/Gibbon/Faces/gibbon_face_angry1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_angry2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_angry3.png'],
 'confused': ['res://images/characters/Gibbon/Faces/gibbon_face_confused1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_confused2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_confused3.png'], 
'neutral': ['res://images/characters/Gibbon/Faces/gibbon_face_neutral.png'],
 'sad': ['res://images/characters/Gibbon/Faces/gibbon_face_sad1.png','res://images/characters/Gibbon/Faces/gibbon_face_sad2.png','res://images/characters/Gibbon/Faces/gibbon_face_sad3.png'],
 'shock': ['res://images/characters/Gibbon/Faces/gibbon_face_shocked1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_shocked2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_shocked3.png'], 
'smitten': ['res://images/characters/Gibbon/Faces/gibbon_face_smitten1.png', 'res://images/characters/Gibbon/Faces/gibbon_face_smitten2.png', 'res://images/characters/Gibbon/Faces/gibbon_face_smitten3.png'], 
'blush': ['res://images/characters/Gibbon/AFL/gibbon_face_blushies.png'], 
	'body':['res://images/characters/Gibbon/gibbon_special1_default.png', 'res://images/characters/Gibbon/gibbon_special2_clenched.png', 'res://images/characters/Gibbon/gibbon_special3_grabby.png', 'res://images/characters/Gibbon/gibbon_special4_handsup.png', 'res://images/characters/Gibbon/gibbon_special5_press.png']
},
'newgle':{'body':['res://images/characters/Gibbon/gibbon_newgle.png']}
		}

	#res://images/characters/Mage/Faces_Campus/mage_face_campus_happy1
	#used mage_face_campus_blush1,2,3 for smitten.

var mage = {
	 'campus': {
		'happy': ['res://images/characters/Mage/Faces_Campus/mage_face_campus_happy1.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_happy2.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_happy3.png'], 
		'angry': ['res://images/characters/Mage/Faces_Campus/mage_face_campus_angry1.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_angry2.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_angry3.png'],
		'confused': ['res://images/characters/Mage/Faces_Campus/mage_face_campus_confused1.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_confused2.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_confused3.png'], 
		'neutral': ['res://images/characters/Mage/Faces_Campus/mage_face_campus_neutral.png'], 
		'sad': ['res://images/characters/Mage/Faces_Campus/mage_face_campus_sad1.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_sad2.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_sad3.png'], 
		'shock': ['res://images/characters/Mage/Faces_Campus/mage_face_campus_shock1.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_shock2.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_shock3.png'], 
		'smitten': ['res://images/characters/Mage/Faces_Campus/mage_face_campus_blush1.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_blush2.png', 'res://images/characters/Mage/Faces_Campus/mage_face_campus_blush3.png'], 
		'blush': ['res://images/characters/Mage/AFL/mage_face_campus_blushies.png'], 
		'body': ['res://images/characters/Mage/mage_campus1.png','res://images/characters/Mage/mage_campus2.png','res://images/characters/Mage/mage_campus3.png','res://images/characters/Mage/mage_campus4.png','res://images/characters/Mage/mage_campus5.png']
		}, 
	'casual': {
		'happy': ['res://images/characters/Mage/Faces_Casual/mage_face_casual_happy1.png', 'res://images/characters/Mage/Faces_Casual/mage_face_casual_happy2.png' ,'res://images/characters/Mage/Faces_Casual/mage_face_casual_happy3.png'], 
		'angry': ['res://images/characters/Mage/Faces_Casual/mage_face_casual_angry1.png', 'res://images/characters/Mage/Faces_Casual/mage_face_casual_angry2.png', 'res://images/characters/Mage/Faces_Casual/mage_face_casual_angry3.png'], 
		'confused': ['res://images/characters/Mage/Faces_Casual/mage_face_casual_confused1.png', 'res://images/characters/Mage/Faces_Casual/mage_face_casual_confused2.png', 'res://images/characters/Mage/Faces_Casual/mage_face_casual_confused3.png'], 
		'neutral': ['res://images/characters/Mage/Faces_Casual/mage_face_casual_neutral.png'], 
		'sad': ['res://images/characters/Mage/Faces_Casual/mage_face_casual_sad1.png', 'res://images/characters/Mage/Faces_Casual/mage_face_casual_sad2.png', 'res://images/characters/Mage/Faces_Casual/mage_face_casual_sad3.png'], 
		'shock': ['res://images/characters/Mage/Faces_Casual/mage_face_casual_shock1.png', 'res://images/characters/Mage/Faces_Casual/mage_face_casual_shock2.png', 'res://images/characters/Mage/Faces_Casual/mage_face_casual_shock3.png'], 
		'smitten': ['res://images/characters/Mage/Faces_Casual/mage_face_casual_blush1.png', 'res://images/characters/Mage/Faces_Casual/mage_face_casual_blush2.png', 'res://images/characters/Mage/Faces_Casual/mage_face_casual_blush3.png'], 
		'blush': ['res://images/characters/Mage/AFL/mage_face_casual_blushies.png'], 
		'body': ['res://images/characters/Mage/mage_casual1.png','res://images/characters/Mage/mage_casual2.png','res://images/characters/Mage/mage_casual3.png','res://images/characters/Mage/mage_casual4.png','res://images/characters/Mage/mage_casual5.png']}
		}

var munchy = { 
	'campus': {
		'happy': ['res://images/characters/Munchy/Faces/munchy_face_happy1.png', 'res://images/characters/Munchy/Faces/munchy_face_happy2.png', 'res://images/characters/Munchy/Faces/munchy_face_happy3.png'], 
		'angry': ['res://images/characters/Munchy/Faces/munchy_face_angry1.png', 'res://images/characters/Munchy/Faces/munchy_face_angry2.png', 'res://images/characters/Munchy/Faces/munchy_face_angry3.png'], 
		'confused': ['res://images/characters/Munchy/Faces/munchy_face_confused1.png', 'res://images/characters/Munchy/Faces/munchy_face_confused2.png', 'res://images/characters/Munchy/Faces/munchy_face_confused3.png'], 
		'neutral': ['res://images/characters/Munchy/Faces/munchy_face_neutral.png'], 
		'sad': ['res://images/characters/Munchy/Faces/munchy_face_sad1.png', 'res://images/characters/Munchy/Faces/munchy_face_sad2.png', 'res://images/characters/Munchy/Faces/munchy_face_sad3.png'], 
		'shock': ['res://images/characters/Munchy/Faces/munchy_face_shocked1.png', 'res://images/characters/Munchy/Faces/munchy_face_shocked2.png', 'res://images/characters/Munchy/Faces/munchy_face_shocked3.png'], 
		'smitten': ['res://images/characters/Munchy/Faces/munchy_face_smitten1.png', 'res://images/characters/Munchy/Faces/munchy_face_smitten2.png', 'res://images/characters/Munchy/Faces/munchy_face_smitten3.png'], 
		'blush': ['res://images/characters/Munchy/AFL/munchy_face_blushies.png'], 
		'body': ['res://images/characters/Munchy/munchy_campus1_default.png', 'res://images/characters/Munchy/munchy_campus2_crossing.png', 'res://images/characters/Munchy/munchy_campus3_squatting.png'], 
		'squatting': {
			'happy': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_happy1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_happy2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_happy3.png'], 
			'angry': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_angry1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_angry2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_angry3.png'], 
			'confused': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_confused1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_confused2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_confused3.png'], 
			'neutral': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_neutral.png'], 
			'sad': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_sad1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_sad2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_sad3.png'], 
			'shock': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_shocked1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_shocked2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_shocked3.png'], 
			'smitten': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_smitten1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_smitten2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_smitten3.png'], 
			'blush': ['res://images/characters/Munchy/AFL/munchy_face_squatting_blushies.png']
			}
		}, 
		'casual': {
			'happy': ['res://images/characters/Munchy/Faces/munchy_face_happy1.png', 'res://images/characters/Munchy/Faces/munchy_face_happy2.png', 'res://images/characters/Munchy/Faces/munchy_face_happy3.png'], 
			'angry': ['res://images/characters/Munchy/Faces/munchy_face_angry1.png', 'res://images/characters/Munchy/Faces/munchy_face_angry2.png', 'res://images/characters/Munchy/Faces/munchy_face_angry3.png'], 
			'confused': ['res://images/characters/Munchy/Faces/munchy_face_confused1.png', 'res://images/characters/Munchy/Faces/munchy_face_confused2.png', 'res://images/characters/Munchy/Faces/munchy_face_confused3.png'], 
			'neutral': ['res://images/characters/Munchy/Faces/munchy_face_neutral.png'], 
			'sad': ['res://images/characters/Munchy/Faces/munchy_face_sad1.png', 'res://images/characters/Munchy/Faces/munchy_face_sad2.png', 'res://images/characters/Munchy/Faces/munchy_face_sad3.png'], 
			'shock': ['res://images/characters/Munchy/Faces/munchy_face_shocked1.png', 'res://images/characters/Munchy/Faces/munchy_face_shocked2.png', 'res://images/characters/Munchy/Faces/munchy_face_shocked3.png'], 
			'smitten': ['res://images/characters/Munchy/Faces/munchy_face_smitten1.png', 'res://images/characters/Munchy/Faces/munchy_face_smitten2.png', 'res://images/characters/Munchy/Faces/munchy_face_smitten3.png'], 
			'blush': ['res://images/characters/Munchy/AFL/munchy_face_blushies.png'], 
			'body': ['res://images/characters/Munchy/munchy_casual1_default.png', 'res://images/characters/Munchy/munchy_casual2_crossing.png', 'res://images/characters/Munchy/munchy_casual3_squatting.png'], 
			'squatting': 
			{
				'happy': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_happy1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_happy2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_happy3.png'], 
				'angry': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_angry1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_angry2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_angry3.png'], 
				'confused': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_confused1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_confused2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_confused3.png'], 
				'neutral': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_neutral.png'], 
				'sad': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_sad1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_sad2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_sad3.png'], 
				'shock': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_shocked1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_shocked2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_shocked3.png'], 
				'smitten': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_smitten1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_smitten2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_smitten3.png'], 
				'blush': ['res://images/characters/Munchy/AFL/munchy_face_squatting_blushies.png']
			}
		},		
		'special': {
			'happy': ['res://images/characters/Munchy/Faces/munchy_face_happy1.png', 'res://images/characters/Munchy/Faces/munchy_face_happy2.png', 'res://images/characters/Munchy/Faces/munchy_face_happy3.png'], 
			'angry': ['res://images/characters/Munchy/Faces/munchy_face_angry1.png', 'res://images/characters/Munchy/Faces/munchy_face_angry2.png', 'res://images/characters/Munchy/Faces/munchy_face_angry3.png'], 
			'confused': ['res://images/characters/Munchy/Faces/munchy_face_confused1.png', 'res://images/characters/Munchy/Faces/munchy_face_confused2.png', 'res://images/characters/Munchy/Faces/munchy_face_confused3.png'], 
			'neutral': ['res://images/characters/Munchy/Faces/munchy_face_neutral.png'], 
			'sad': ['res://images/characters/Munchy/Faces/munchy_face_sad1.png', 'res://images/characters/Munchy/Faces/munchy_face_sad2.png', 'res://images/characters/Munchy/Faces/munchy_face_sad3.png'], 
			'shock': ['res://images/characters/Munchy/Faces/munchy_face_shocked1.png', 'res://images/characters/Munchy/Faces/munchy_face_shocked2.png', 'res://images/characters/Munchy/Faces/munchy_face_shocked3.png'], 
			'smitten': ['res://images/characters/Munchy/Faces/munchy_face_smitten1.png', 'res://images/characters/Munchy/Faces/munchy_face_smitten2.png', 'res://images/characters/Munchy/Faces/munchy_face_smitten3.png'], 
			'blush': ['res://images/characters/Munchy/AFL/munchy_face_blushies.png'], 
			'body': ['res://images/characters/Munchy/munchy_special1_default.png', 'res://images/characters/Munchy/munchy_special2_crossing.png', 'res://images/characters/Munchy/munchy_special3_squatting.png'], 
			'squatting': 
			{
				'happy': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_happy1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_happy2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_happy3.png'], 
				'angry': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_angry1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_angry2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_angry3.png'], 
				'confused': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_confused1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_confused2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_confused3.png'], 
				'neutral': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_neutral.png'], 
				'sad': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_sad1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_sad2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_sad3.png'], 
				'shock': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_shocked1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_shocked2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_shocked3.png'], 
				'smitten': ['res://images/characters/Munchy/SquatFaces/munchy_face_squatting_smitten1.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_smitten2.png', 'res://images/characters/Munchy/SquatFaces/munchy_face_squatting_smitten3.png'], 
				'blush': ['res://images/characters/Munchy/AFL/munchy_face_squatting_blushies.png']
			}
		}
	}
var nate = {
		'afl':['res://images/characters/Nate/AFL/nate_afl_purple_nates.png',
		'res://images/characters/Nate/AFL/nate_afl_kaminashades.png',
		'res://images/characters/Nate/AFL/nate_afl_beard.png'
	],
	'campus': {
		'happy': ['res://images/characters/Nate/Faces/nate_face_happy1.png', 'res://images/characters/Nate/Faces/nate_face_happy2.png', 'res://images/characters/Nate/Faces/nate_face_happy3.png'], 
		'angry': ['res://images/characters/Nate/Faces/nate_face_angry1.png', 'res://images/characters/Nate/Faces/nate_face_angry2.png', 'res://images/characters/Nate/Faces/nate_face_angry3.png'], 
		'confused': ['res://images/characters/Nate/Faces/nate_face_confused1.png', 'res://images/characters/Nate/Faces/nate_face_confused2.png', 'res://images/characters/Nate/Faces/nate_face_confused3.png'], 
		'neutral': ['res://images/characters/Nate/Faces/nate_face_neutral.png'], 
		'sad': ['res://images/characters/Nate/Faces/nate_face_sad1.png', 'res://images/characters/Nate/Faces/nate_face_sad2.png', 'res://images/characters/Nate/Faces/nate_face_sad3.png'], 
		'shock': ['res://images/characters/Nate/Faces/nate_face_shock1.png', 'res://images/characters/Nate/Faces/nate_face_shock2.png', 'res://images/characters/Nate/Faces/nate_face_shock3.png'], 
		'smitten': ['res://images/characters/Nate/Faces/nate_face_smitten1.png', 'res://images/characters/Nate/Faces/nate_face_smitten2.png', 'res://images/characters/Nate/Faces/nate_face_smitten3.png'], 
		'blush': ['res://images/characters/Nate/AFL/nate_face_blushies.png'], 
		'body': ['res://images/characters/Nate/nate_campus1_standing.png', 'res://images/characters/Nate/nate_campus2_smoking.png', 'res://images/characters/Nate/nate_campus3_pointing.png', 'res://images/characters/Nate/nate_campus4_papers.png','res://images/characters/Nate/nate_campus5_maniacal.png' ]
		}, 
	'casual': {
		
		'happy': ['res://images/characters/Nate/Faces/nate_face_happy1.png', 'res://images/characters/Nate/Faces/nate_face_happy2.png', 'res://images/characters/Nate/Faces/nate_face_happy3.png'], 
		'angry': ['res://images/characters/Nate/Faces/nate_face_angry1.png', 'res://images/characters/Nate/Faces/nate_face_angry2.png', 'res://images/characters/Nate/Faces/nate_face_angry3.png'], 
		'confused': ['res://images/characters/Nate/Faces/nate_face_confused1.png', 'res://images/characters/Nate/Faces/nate_face_confused2.png', 'res://images/characters/Nate/Faces/nate_face_confused3.png'], 
		'neutral': ['res://images/characters/Nate/Faces/nate_face_neutral.png'], 
		'sad': ['res://images/characters/Nate/Faces/nate_face_sad1.png', 'res://images/characters/Nate/Faces/nate_face_sad2.png', 'res://images/characters/Nate/Faces/nate_face_sad3.png'], 
		'shock': ['res://images/characters/Nate/Faces/nate_face_shock1.png', 'res://images/characters/Nate/Faces/nate_face_shock2.png', 'res://images/characters/Nate/Faces/nate_face_shock3.png'], 
		'smitten': ['res://images/characters/Nate/Faces/nate_face_smitten1.png', 'res://images/characters/Nate/Faces/nate_face_smitten2.png', 'res://images/characters/Nate/Faces/nate_face_smitten3.png'], 
		'blush': ['res://images/characters/Nate/AFL/nate_face_blushies.png'],  
		'body': ['res://images/characters/Nate/nate_casual1_standing.png', 'res://images/characters/Nate/nate_casual2_smoking.png', 'res://images/characters/Nate/nate_casual3_pointing.png', 'res://images/characters/Nate/nate_casual4_papers.png', 'res://images/characters/Nate/nate_casual5_maniacal.png']
		},
	'special': {
		
		'happy': ['res://images/characters/Nate/Faces/nate_face_happy1.png', 'res://images/characters/Nate/Faces/nate_face_happy2.png', 'res://images/characters/Nate/Faces/nate_face_happy3.png'], 
		'angry': ['res://images/characters/Nate/Faces/nate_face_angry1.png', 'res://images/characters/Nate/Faces/nate_face_angry2.png', 'res://images/characters/Nate/Faces/nate_face_angry3.png'], 
		'confused': ['res://images/characters/Nate/Faces/nate_face_confused1.png', 'res://images/characters/Nate/Faces/nate_face_confused2.png', 'res://images/characters/Nate/Faces/nate_face_confused3.png'], 
		'neutral': ['res://images/characters/Nate/Faces/nate_face_neutral.png'], 
		'sad': ['res://images/characters/Nate/Faces/nate_face_sad1.png', 'res://images/characters/Nate/Faces/nate_face_sad2.png', 'res://images/characters/Nate/Faces/nate_face_sad3.png'], 
		'shock': ['res://images/characters/Nate/Faces/nate_face_shock1.png', 'res://images/characters/Nate/Faces/nate_face_shock2.png', 'res://images/characters/Nate/Faces/nate_face_shock3.png'], 
		'smitten': ['res://images/characters/Nate/Faces/nate_face_smitten1.png', 'res://images/characters/Nate/Faces/nate_face_smitten2.png', 'res://images/characters/Nate/Faces/nate_face_smitten3.png'], 
		'blush': ['res://images/characters/Nate/AFL/nate_face_blushies.png'],  
		'body': ['res://images/characters/Nate/nate_special1_standing.png', 'res://images/characters/Nate/nate_special2_smoking.png', 'res://images/characters/Nate/nate_special3_pointing.png', 'res://images/characters/Nate/nate_special4_papers.png', 'res://images/characters/Nate/nate_special5_maniacal.png']
		}
		}
var jesse = {
		'campus': {
			'happy': ['res://images/characters/Jesse/faces campus/jesse_face_campus_happyMIN.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_happyMED.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_happyMAX.png'], 
			'angry': ['res://images/characters/Jesse/faces campus/jesse_face_campus_angryMIN.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_angryMED.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_angryMAX.png'], 
			'confused': ['res://images/characters/Jesse/faces campus/jesse_face_campus_confusedMIN.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_confusedMED.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_confusedMAX.png'], 
			'neutral': ['res://images/characters/Jesse/faces campus/jesse_face_campus_neutral.png'], 
			'sad': ['res://images/characters/Jesse/faces campus/jesse_face_campus_sadMIN.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_sadMED.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_sadMAX.png'], 
			'shock': ['res://images/characters/Jesse/faces campus/jesse_face_campus_shockMIN.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_shockMED.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_shockMAX.png'], 
			'smitten': ['res://images/characters/Jesse/faces campus/jesse_face_campus_smittenMIN.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_smittenMED.png', 'res://images/characters/Jesse/faces campus/jesse_face_campus_smittenMAX.png'], 
			'blush': ['res://images/characters/Jesse/AFL/jesse_face_blushiesMIN.png', 'res://images/characters/Jesse/AFL/jesse_face_blushiesMAX.png'], 
			'body': ['res://images/characters/Jesse/jesse_campus_1.png', 'res://images/characters/Jesse/jesse_campus_2.png', 'res://images/characters/Jesse/jesse_campus_3.png', 'res://images/characters/Jesse/jesse_campus_4.png', 'res://images/characters/Jesse/jesse_campus_5.png']}, 
		'casual': {
			'happy': ['res://images/characters/Jesse/faces casual/jesse_face_casual_happyMIN.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_happyMED.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_happyMAX.png'], 
			'angry': ['res://images/characters/Jesse/faces casual/jesse_face_casual_angryMIN.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_angryMED.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_angryMAX.png'], 
			'confused': ['res://images/characters/Jesse/faces casual/jesse_face_casual_confusedMIN.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_confusedMED.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_confusedMAX.png'], 
			'neutral': ['res://images/characters/Jesse/faces casual/jesse_face_casual_neutral.png'], 
			'sad': ['res://images/characters/Jesse/faces casual/jesse_face_casual_sadMIN.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_sadMED.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_sadMAX.png'], 
			'shock': ['res://images/characters/Jesse/faces casual/jesse_face_casual_shockMIN.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_shockMED.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_shockMAX.png'], 
			'smitten': ['res://images/characters/Jesse/faces casual/jesse_face_casual_smittenMIN.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_smittenMED.png', 'res://images/characters/Jesse/faces casual/jesse_face_casual_smittenMAX.png'], 
			'blush': ['res://images/characters/Jesse/AFL/jesse_face_blushiesMIN.png', 'res://images/characters/Jesse/AFL/jesse_face_blushiesMAX.png'], 
			'body': ['res://images/characters/Jesse/jesse_casual_1.png', 'res://images/characters/Jesse/jesse_casual_2.png', 'res://images/characters/Jesse/jesse_casual_3.png', 'res://images/characters/Jesse/jesse_casual_4.png', 'res://images/characters/Jesse/jesse_casual_5.png']
			},
		'special': {
			'happy': ['res://images/characters/Jesse/faces special/jesse_face_special_happyMIN.png', 'res://images/characters/Jesse/faces special/jesse_face_special_happyMED.png', 'res://images/characters/Jesse/faces special/jesse_face_special_happyMAX.png'], 
			'angry': ['res://images/characters/Jesse/faces special/jesse_face_special_angryMIN.png', 'res://images/characters/Jesse/faces special/jesse_face_special_angryMED.png', 'res://images/characters/Jesse/faces special/jesse_face_special_angryMAX.png'], 
			'confused': ['res://images/characters/Jesse/faces special/jesse_face_special_confusedMIN.png', 'res://images/characters/Jesse/faces special/jesse_face_special_confusedMED.png', 'res://images/characters/Jesse/faces special/jesse_face_special_confusedMAX.png'], 
			'neutral': ['res://images/characters/Jesse/faces special/jesse_face_special_neutral.png'], 
			'sad': ['res://images/characters/Jesse/faces special/jesse_face_special_sadMIN.png', 'res://images/characters/Jesse/faces special/jesse_face_special_sadMED.png', 'res://images/characters/Jesse/faces special/jesse_face_special_sadMAX.png'], 
			'shock': ['res://images/characters/Jesse/faces special/jesse_face_special_shockMIN.png', 'res://images/characters/Jesse/faces special/jesse_face_special_shockMED.png', 'res://images/characters/Jesse/faces special/jesse_face_special_shockMAX.png'], 
			'smitten': ['res://images/characters/Jesse/faces special/jesse_face_special_smittenMIN.png', 'res://images/characters/Jesse/faces special/jesse_face_special_smittenMED.png', 'res://images/characters/Jesse/faces special/jesse_face_special_smittenMAX.png'], 
			'blush': ['res://images/characters/Jesse/AFL/jesse_face_blushiesMIN.png', 'res://images/characters/Jesse/AFL/jesse_face_blushiesMAX.png'], 
			'body': ['res://images/characters/Jesse/jesse_special_1.png', 'res://images/characters/Jesse/jesse_special_2.png', 'res://images/characters/Jesse/jesse_special_3.png', 'res://images/characters/Jesse/jesse_special_4.png', 'res://images/characters/Jesse/jesse_special_5.png']
			}
		}

var tom = {
		'pose1':{
			'afl': ['res://images/characters/Tom/AFL/tom_afl_facemask.png'], 
			'happy': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_happyMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_happyMAX.png'], 
			'angry': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_angryMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_angryMAX.png'], 
			'confused': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_confusedMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_confusedMAX.png'], 
			'neutral': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_neutral.png'], 
			'sad': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_sadMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_sadMAX.png'], 
			'shock': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_shockMIN.png','res://images/characters/Tom/faces_1_2/tom_face_1_2_shockMAX.png'], 
			'smitten':['res://images/characters/Tom/faces_1_2/tom_face_1_2_smittenMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_smittenMAX.png'],
			'drunk':['res://images/characters/Tom/faces_1_2/tom_face_1_2_drunkMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_drunkMAX.png'],
			'blush': null, 
			'body': ['res://images/characters/Tom/tom_1.png', 'res://images/characters/Tom/tom_2.png', 'res://images/characters/Tom/tom_champagne.png', 'res://images/characters/Tom/tom_cider.png', 'res://images/characters/Tom/tom_huel.png', 'res://images/characters/Tom/tom_mic.png', 'res://images/characters/Tom/tom_whiskey.png']
			},
		'pose2':{
			'afl': ['res://images/characters/Tom/AFL/tom_afl_facemask.png'], 
			'happy': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_happyMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_happyMAX.png'], 
			'angry': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_angryMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_angryMAX.png'], 
			'confused': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_confusedMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_confusedMAX.png'], 
			'neutral': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_neutral.png'], 
			'sad': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_sadMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_sadMAX.png'], 
			'shock': ['res://images/characters/Tom/faces_1_2/tom_face_1_2_shockMIN.png','res://images/characters/Tom/faces_1_2/tom_face_1_2_shockMAX.png'], 
			'smitten':['res://images/characters/Tom/faces_1_2/tom_face_1_2_smittenMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_smittenMAX.png'],
			'drunk':['res://images/characters/Tom/faces_1_2/tom_face_1_2_drunkMIN.png', 'res://images/characters/Tom/faces_1_2/tom_face_1_2_drunkMAX.png'],
			'blush': null, 
			'body': ['res://images/characters/Tom/tom_2.png']
		},
		'pose3':{
			'afl': ['res://images/characters/Tom/AFL/tom_afl_facemask.png'], 
			'happy': ['res://images/characters/Tom/faces_3/tom_face_3_happyMIN.png', 'res://images/characters/Tom/faces_3/tom_face_3_happyMAX.png'], 
			'angry': ['res://images/characters/Tom/faces_3/tom_face_3_angryMIN.png', 'res://images/characters/Tom/faces_3/tom_face_3_angryMAX.png'], 
			'confused': ['res://images/characters/Tom/faces_3/tom_face_3_confusedMIN.png', 'res://images/characters/Tom/faces_3/tom_face_3_confusedMAX.png'], 
			'neutral': ['res://images/characters/Tom/faces_3/tom_face_3_neutral.png'], 
			'sad': ['res://images/characters/Tom/faces_3/tom_face_3_sadMIN.png', 'res://images/characters/Tom/faces_3/tom_face_3_sadMAX.png'], 
			'shock': ['res://images/characters/Tom/faces_3/tom_face_3_shockMIN.png','res://images/characters/Tom/faces_3/tom_face_3_shockMAX.png'], 
			'smitten':['res://images/characters/Tom/faces_3/tom_face_3_smittenMIN.png', 'res://images/characters/Tom/faces_3/tom_face_3_smittenMAX.png'],
			'drunk':['res://images/characters/Tom/faces_3/tom_face_3_drunkMIN.png', 'res://images/characters/Tom/faces_3/tom_face_3_drunkMAX.png'],
			'blush': null, 
			'body': ['res://images/characters/Tom/tom_3.png']
			},
		'pose4':{
			'afl': ['res://images/characters/Tom/AFL/tom_afl_facemask.png'], 
			'happy': ['res://images/characters/Tom/faces_4/tom_face_4_happyMIN.png', 'res://images/characters/Tom/faces_4/tom_face_4_happyMAX.png'], 
			'angry': ['res://images/characters/Tom/faces_4/tom_face_4_angryMIN.png', 'res://images/characters/Tom/faces_4/tom_face_4_angryMAX.png'], 
			'confused': ['res://images/characters/Tom/faces_4/tom_face_4_confusedMIN.png', 'res://images/characters/Tom/faces_4/tom_face_4_confusedMAX.png'], 
			'neutral': ['res://images/characters/Tom/faces_4/tom_face_4_neutral.png'], 
			'sad': ['res://images/characters/Tom/faces_4/tom_face_4_sadMIN.png', 'res://images/characters/Tom/faces_4/tom_face_4_sadMAX.png'], 
			'shock': ['res://images/characters/Tom/faces_4/tom_face_4_shockMIN.png','res://images/characters/Tom/faces_4/tom_face_4_shockMAX.png'], 
			'smitten':['res://images/characters/Tom/faces_4/tom_face_4_smittenMIN.png', 'res://images/characters/Tom/faces_4/tom_face_4_smittenMAX.png'],
			'drunk':['res://images/characters/Tom/faces_4/tom_face_4_drunkMIN.png', 'res://images/characters/Tom/faces_4/tom_face_4_drunkMAX.png'],
			'blush': null, 
			'body': ['res://images/characters/Tom/tom_3.png']
			},
		}

var endlesswar = {
				'afl': [],
				'happy': ['res://images/characters/Endless War/Faces/endlesswar_face_happy1.png', 'res://images/characters/Endless War/Faces/endlesswar_face_happy2.png', 'res://images/characters/Endless War/Faces/endlesswar_face_happy3.png'],
				'angry': ['res://images/characters/Endless War/Faces/endlesswar_face_angry1.png', 'res://images/characters/Endless War/Faces/endlesswar_face_angry2.png', 'res://images/characters/Endless War/Faces/endlesswar_face_angry3.png'],
				'confused': ['res://images/characters/Endless War/Faces/endlesswar_face_confused1.png', 'res://images/characters/Endless War/Faces/endlesswar_face_confused2.png', 'res://images/characters/Endless War/Faces/endlesswar_face_confused3.png'],
				'neutral': ['res://images/characters/Endless War/Faces/endlesswar_face_neutral.png'],
				'sad': ['res://images/characters/Endless War/Faces/endlesswar_face_sad1.png', 'res://images/characters/Endless War/Faces/endlesswar_face_sad2.png', 'res://images/characters/Endless War/Faces/endlesswar_face_sad3.png'],
				'shock': ['res://images/characters/Endless War/Faces/endlesswar_face_shocked1.png', 'res://images/characters/Endless War/Faces/endlesswar_face_shocked2.png', 'res://images/characters/Endless War/Faces/endlesswar_face_shocked3.png'],
				'smitten': ['res://images/characters/Endless War/Faces/endlesswar_face_smitten1.png', 'res://images/characters/Endless War/Faces/endlesswar_face_smitten2.png', 'res://images/characters/Endless War/Faces/endlesswar_face_smitten3.png'],
				'blush': ['res://images/characters/Endless War/AFL/endlesswar_face_blushies1.png', 'res://images/characters/Endless War/AFL/endlesswar_face_blushies2.png', 'res://images/characters/Endless War/AFL/endlesswar_face_blusies3.png'],
				'body': ['res://images/characters/Endless War/endlesswar_campus1_stand.png'],
				'knife': {
					'happy': ['res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_happy1.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_happy2.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_happy3.png'],
					'angry': ['res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_angry1.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_angry2.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_angry3.png'],
					'confused': ['res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_confused1.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_confused2.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_confused3.png'],
					'neutral': ['res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_neutral.png'],
					'sad': ['res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_sad1.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_sad2.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_sad3.png'],
					'shock': ['res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_shocked1.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_shocked2.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_shocked3.png'],
					'smitten': ['res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_smitten1.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_smitten2.png', 'res://images/characters/Endless War/Knife Faces/endlesswar_face_knife_smitten3.png'],
					'blush': ['res://images/characters/Endless War/AFL/endlesswar_face_knife_blushies1.png', 'res://images/characters/Endless War/AFL/endlesswar_face_knife_blushies2.png', 'res://images/characters/Endless War/AFL/endlesswar_face_knife_blushies3.png'],
					'body': ['res://images/characters/Endless War/endlesswar_campus2_knife.png']
					},
				'cross': {
					'happy': ['res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_happy1.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_happy2.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_happy3.png'],
					'angry': ['res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_angry1.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_angry2.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_angry3.png'],
					'confused': ['res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_confused1.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_confused2.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_confused3.png'],
					'neutral': ['res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_neutral.png'],
					'sad': ['res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_sad1.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_sad2.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_sad3.png'],
					'shock': ['res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_shock1.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_shock2.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_shock3.png'],
					'smitten': ['res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_smitten1.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_smitten2.png', 'res://images/characters/Endless War/Cross Faces/endlesswar_face_cross_smitten3.png'],
					'blush': ['res://images/characters/Endless War/AFL/endlesswar_face_cross_blushies1.png', 'res://images/characters/Endless War/AFL/endlesswar_face_cross_blushies2.png', 'res://images/characters/Endless War/AFL/endlesswar_face_cross_blushies3.png'],
					'body': ['res://images/characters/Endless War/endlesswar_campus3_cross.png']
					}
				}

var ben = {
	'afl': ['res://images/characters/Ben/AFL/ben_afl_cloud.png', 'res://images/characters/Ben/AFL/ben_afl_horn.png', 'res://images/characters/Ben/AFL/ben_afl_point.png'],
	'campus': {
			'happy': ['res://images/characters/Ben/face/ben_face_happyMIN.png', 'res://images/characters/Ben/face/ben_face_happyMAX.png'],
			'angry': ['res://images/characters/Ben/face/ben_face_angryMIN.png', 'res://images/characters/Ben/face/ben_face_angryMAX.png'],
			'confused': ['res://images/characters/Ben/face/ben_face_confusedMIN.png', 'res://images/characters/Ben/face/ben_face_confusedMAX.png'],
			'neutral': ['res://images/characters/Ben/face/ben_face_neutral.png'],
			'sad': ['res://images/characters/Ben/face/ben_face_sadMIN.png', 'res://images/characters/Ben/face/ben_face_sadMAX.png'],
			'shock': ['res://images/characters/Ben/face/ben_face_shockMIN.png', 'res://images/characters/Ben/face/ben_face_shockMAX.png'],
			'smitten': ['res://images/characters/Ben/face/ben_face_smittenMIN.png', 'res://images/characters/Ben/face/ben_face_smittenMAX.png'],
			'blush': ['res://images/characters/Ben/AFL/ben_face_blush.png'],
			'body': ['res://images/characters/Ben/ben_campus_base.png', 'res://images/characters/Ben/ben_campus_dab.png', 'res://images/characters/Ben/ben_campus_exasp.png', 'res://images/characters/Ben/ben_campus_point.png', 'res://images/characters/Ben/ben_campus_slouch.png']
		}, 
		'casual': {
			'happy': ['res://images/characters/Ben/face/ben_face_happyMIN.png', 'res://images/characters/Ben/face/ben_face_happyMAX.png'],
			'angry': ['res://images/characters/Ben/face/ben_face_angryMIN.png', 'res://images/characters/Ben/face/ben_face_angryMAX.png'],
			'confused': ['res://images/characters/Ben/face/ben_face_confusedMIN.png', 'res://images/characters/Ben/face/ben_face_confusedMAX.png'],
			'neutral': ['res://images/characters/Ben/face/ben_face_neutral.png'],
			'sad': ['res://images/characters/Ben/face/ben_face_sadMIN.png', 'res://images/characters/Ben/face/ben_face_sadMAX.png'],
			'shock': ['res://images/characters/Ben/face/ben_face_shockMIN.png', 'res://images/characters/Ben/face/ben_face_shockMAX.png'],
			'smitten': ['res://images/characters/Ben/face/ben_face_smittenMIN.png', 'res://images/characters/Ben/face/ben_face_smittenMAX.png'],
			'blush': ['res://images/characters/Ben/AFL/ben_face_blush.png'],
			'body': ['res://images/characters/Ben/ben_casual_base.png', 'res://images/characters/Ben/ben_casual_dab.png', 'res://images/characters/Ben/ben_casual_exasp.png', 'res://images/characters/Ben/ben_casual_fat.png', 'res://images/characters/Ben/ben_casual_fruit.png', 'res://images/characters/Ben/ben_casual_point.png', 'res://images/characters/Ben/ben_casual_slouch.png']
		},
		'special': {
			'happy': ['res://images/characters/Ben/face/ben_face_happyMIN.png', 'res://images/characters/Ben/face/ben_face_happyMAX.png'],
			'angry': ['res://images/characters/Ben/face/ben_face_angryMIN.png', 'res://images/characters/Ben/face/ben_face_angryMAX.png'],
			'confused': ['res://images/characters/Ben/face/ben_face_confusedMIN.png', 'res://images/characters/Ben/face/ben_face_confusedMAX.png'],
			'neutral': ['res://images/characters/Ben/face/ben_face_neutral.png'],
			'sad': ['res://images/characters/Ben/face/ben_face_sadMIN.png', 'res://images/characters/Ben/face/ben_face_sadMAX.png'],
			'shock': ['res://images/characters/Ben/face/ben_face_shockMIN.png', 'res://images/characters/Ben/face/ben_face_shockMAX.png'],
			'smitten': ['res://images/characters/Ben/face/ben_face_smittenMIN.png', 'res://images/characters/Ben/face/ben_face_smittenMAX.png'],
			'blush': ['res://images/characters/Ben/AFL/ben_face_blush.png'],
			'body': ['res://images/characters/Ben/ben_formal_base.png', 'res://images/characters/Ben/ben_formal_exasp.png', 'res://images/characters/Ben/ben_formal_point.png']
		}
	}

var davoo = {
			'campus':{
				'angry': ['res://images/characters/Davoo/face/davoo_face_angryMIN.png', 'res://images/characters/Davoo/face/davoo_face_angryMAX.png'],
				'confused': ['res://images/characters/Davoo/face/davoo_face_confusedMIN.png', 'res://images/characters/Davoo/face/davoo_face_confusedMAX.png'],
				'drunk': ['res://images/characters/Davoo/face/davoo_face_drunkMIN.png', 'res://images/characters/Davoo/face/davoo_face_drunkMAX.png'],
				'happy': ['res://images/characters/Davoo/face/davoo_face_happyMIN.png', 'res://images/characters/Davoo/face/davoo_face_happyMAX.png'],
				'neutral': ['res://images/characters/Davoo/face/davoo_face_neutral.png'],
				'sad': ['res://images/characters/Davoo/face/davoo_face_sadMIN.png', 'res://images/characters/Davoo/face/davoo_face_sadMAX.png'],
				'shock': ['res://images/characters/Davoo/face/davoo_face_shockMIN.png', 'res://images/characters/Davoo/face/davoo_face_shockMAX.png'],
				'smitten': ['res://images/characters/Davoo/face/davoo_face_smittenMIN.png', 'res://images/characters/Davoo/face/davoo_face_smittenMAX.png'],
				'body': ['res://images/characters/Davoo/davoo_campus_explaining.png', 'res://images/characters/Davoo/davoo_campus_fidgeting.png', 'res://images/characters/Davoo/davoo_campus_greeting.png', 'res://images/characters/Davoo/davoo_campus_neutral.png', 'res://images/characters/Davoo/davoo_campus_thinking.png'],
				'drunksmile': ['res://images/characters/Davoo/face/davoo_face_drunksmile.png'],
				'drunkdrool': ['res://images/characters/Davoo/face/davoo_face_drunkdrool.png'],
				'catboy': ['res://images/characters/Davoo/face/davoo_face_catboy.png']
			},
			'special': {
				'angry': ['res://images/characters/Davoo/face/davoo_face_angryMIN.png', 'res://images/characters/Davoo/face/davoo_face_angryMAX.png'],
				'confused': ['res://images/characters/Davoo/face/davoo_face_confusedMIN.png', 'res://images/characters/Davoo/face/davoo_face_confusedMAX.png'],
				'drunk': ['res://images/characters/Davoo/face/davoo_face_drunkMIN.png', 'res://images/characters/Davoo/face/davoo_face_drunkMAX.png'],
				'happy': ['res://images/characters/Davoo/face/davoo_face_happyMIN.png', 'res://images/characters/Davoo/face/davoo_face_happyMAX.png'],
				'neutral': ['res://images/characters/Davoo/face/davoo_face_neutral.png'],
				'sad': ['res://images/characters/Davoo/face/davoo_face_sadMIN.png', 'res://images/characters/Davoo/face/davoo_face_sadMAX.png'],
				'shock': ['res://images/characters/Davoo/face/davoo_face_shockMIN.png', 'res://images/characters/Davoo/face/davoo_face_shockMAX.png'],
				'smitten': ['res://images/characters/Davoo/face/davoo_face_smittenMIN.png', 'res://images/characters/Davoo/face/davoo_face_smittenMAX.png'],
				'body': ['res://images/characters/Davoo/davoo_special.png'],
				'drunksmile': ['res://images/characters/Davoo/face/davoo_face_drunksmile.png'],
				'drunkdrool': ['res://images/characters/Davoo/face/davoo_face_drunkdrool.png'],
				'catboy': ['res://images/characters/Davoo/face/davoo_face_catboy.png']
			},
			'hazmat': {
				'angry': ['res://images/characters/Davoo/davoo_hazmat_angryMIN.png', 'res://images/characters/Davoo/davoo_hazmat_angryMAX.png'],
				'confused': ['res://images/characters/Davoo/davoo_confusedMIN.png', 'res://images/characters/Davoo/davoo_confusedMAX.png'],
				'curious': ['res://images/characters/Davoo/davoo_hazmat_curious.png'],
				'neutral': ['res://images/characters/Davoo/davoo_hazmat_neutral.png'],
				'sad': ['res://images/characters/Davoo/davoo_hazmat_sadMIN.png', 'res://images/characters/Davoo/davoo_hazmat_sadMAX.png'],
				'shock': ['res://images/characters/Davoo/davoo_hazmat_shockMIN.png', 'res://images/characters/Davoo/davoo_hazmat_shockMAX.png'],
				'thinking':['res://images/characters/Davoo/davoo_hazmat_thinking.png'],
				'smitten': ['res://images/characters/Davoo/davoo_hazmat_smittenMIN.png', 'res://images/characters/Davoo/davoo_hazmat_smittenMED.png', 'res://images/characters/Davoo/davoo_hazmat_smittenMAX.png']
			}
		}

# Function to load duplicates.
func _ready():
	azumi.casual.angry = azumi.campus.angry
	azumi.casual.confused = azumi.campus.confused
	azumi.casual.happy = azumi.campus.happy
	azumi.casual.neutral = azumi.campus.neutral
	azumi.casual.sad = azumi.campus.sad
	azumi.casual.shock = azumi.campus.shock
	azumi.casual.smitten = azumi.campus.smitten
	azumi.casual.blush = azumi.campus.blush
	coltcorona.gun.angry = coltcorona.feetguitar.angry
	coltcorona.gun.confused = coltcorona.feetguitar.confused
	coltcorona.gun.happy = coltcorona.feetguitar.happy
	coltcorona.gun.neutral = coltcorona.feetguitar.neutral
	coltcorona.gun.sad = coltcorona.feetguitar.sad
	coltcorona.gun.shock = coltcorona.feetguitar.shock
	coltcorona.gun.smitten = coltcorona.feetguitar.smitten
	coltcorona.gun.blush = coltcorona.feetguitar.blush
	coltcorona.thisvideo.angry = coltcorona.feetguitar.angry
	coltcorona.thisvideo.confused = coltcorona.feetguitar.confused
	coltcorona.thisvideo.happy = coltcorona.feetguitar.happy
	coltcorona.thisvideo.neutral = coltcorona.feetguitar.neutral
	coltcorona.thisvideo.sad = coltcorona.feetguitar.sad
	coltcorona.thisvideo.shock = coltcorona.feetguitar.shock
	coltcorona.thisvideo.smitten = coltcorona.feetguitar.smitten
	coltcorona.thisvideo.blush = coltcorona.feetguitar.blush
	#I added these because some davoo lines weren't specifying campus etc.
	#and I just wanted past the crash, these may be entirely unneeded now
	davoo.angry = davoo.campus.angry
	davoo.confused = davoo.campus.angry
	davoo.drunk = davoo.campus.drunk
	davoo.happy = davoo.campus.happy
	davoo.neutral = davoo.campus.neutral
	davoo.sad = davoo.campus.sad
	davoo.shock = davoo.campus.shock
	davoo.smitten = davoo.campus.smitten
	davoo.body = davoo.campus.body
	davoo.drunksmile = davoo.campus.drunksmile
	davoo.drunkdrool = davoo.campus.drunkdrool
	davoo.catboy = davoo.campus.catboy
	check_all_character_art_exists_and_precache_video()
	
func check_all_character_art_exists_and_precache_video():
	var file = File.new()
	var characters_to_check = ["nine11", "ephraim", "k1p", "magicks", "schrafft", "smearg", "copkillers", "kazee", "may", "michelle", "actiongiraffe", "digi", "artsofartso", "adelram", "azumi", "brunswick", "cerise", "coltcorona", "connor", "crocs", "drugdealer", "geoff", "gungirl", "lethal", "lordofghosts", "magda", "mumkeyjones", "pcpguy", "redman", "russel", "snob", "sophia", "hussiefox", "v", "vincent", "clara", "maygib", "thoth", "gibbon", "mage", "munchy", "nate", "jesse", "tom", "endlesswar", "ben", "davoo"]
	for character in characters_to_check:
		var art = get(character)
		var depth_search = [art]
		while depth_search.size() > 0:
			var first = depth_search.pop_front()
			if typeof(first) == TYPE_DICTIONARY:
				for val in first.values():
					depth_search.append(val)
			elif typeof(first) == TYPE_ARRAY:
				for val in first:
					depth_search.append(val)
			elif typeof(first) == TYPE_STRING:
				if not file.file_exists(first):
					print('Error: The given content ' + first + ' does not exist!')
				if first.ends_with(".ogv"):
					load(first)
					
func precache_videos(display):
	var file = File.new()
	var characters_to_check = ["digi", "artsofartso"]
	for character in characters_to_check:
		var art = get(character)
		var depth_search = [art]
		while depth_search.size() > 0:
			var first = depth_search.pop_front()
			if typeof(first) == TYPE_DICTIONARY:
				for val in first.values():
					depth_search.append(val)
			elif typeof(first) == TYPE_ARRAY:
				for val in first:
					depth_search.append(val)
			elif typeof(first) == TYPE_STRING:
				if not file.file_exists(first):
					print('Error: The given content ' + first + ' does not exist!')
				if first.ends_with(".ogv"):
					display.precache_vid(first)
