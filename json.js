const firebase = require("firebase");
require("firebase/firestore");
firebase.initializeApp({
    apiKey: "AIzaSyA7dyDfFXnNGnQIxH2vI_y91tSeGRWILnA",
    authDomain: "igreja-4019a.firebaseapp.com",
    projectId: "igreja-4019a",
  });
  
var db = firebase.firestore();

var menu =[  
    {
        "igreja": "02 de Julho",
        "contrato": 7001959926,
        "matricula": "SAAE-24552-2"
      },
      {
        "igreja": "15 de Novembro",
        "contrato": 7036766721,
        "matricula": "SAAE-23461-7"
      },
      {
        "igreja": "3 Iasd Capoeirucu",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Abare",
        "contrato": 231272429,
        "matricula": 68997736
      },
      {
        "igreja": "Acajutiba",
        "contrato": 25231260,
        "matricula": 72097655
      },
      {
        "igreja": "Acupe",
        "contrato": 23377918,
        "matricula": 80852203
      },
      {
        "igreja": "Agua Branca - Rio Real",
        "contrato": 7048582731,
        "matricula": 177731141
      },
      {
        "igreja": "Agua Branca",
        "contrato": 7044140718,
        "matricula": ""
      },
      {
        "igreja": "Agua Fria",
        "contrato": 225782024,
        "matricula": 80945546
      },
      {
        "igreja": "Agua Grande",
        "contrato": 204662614,
        "matricula": 89010671
      },
      {
        "igreja": "Alagoinhas - Sede",
        "contrato": 7042826701,
        "matricula": "SAAE-3037-9"
      },
      {
        "igreja": "Alagoinhas IV",
        "contrato": 7028105562,
        "matricula": "SAAE-60572-5"
      },
      {
        "igreja": "Alagoinhas Velha",
        "contrato": 13714401,
        "matricula": "SAAE-16911-0"
      },
      {
        "igreja": "Alecrim",
        "contrato": 7013720007,
        "matricula": 149426208
      },
      {
        "igreja": "Algodoes",
        "contrato": "",
        "matricula": 145041590
      },
      {
        "igreja": "Alto Bonito",
        "contrato": 7039157114,
        "matricula": ""
      },
      {
        "igreja": "Alto de Fora",
        "contrato": "",
        "matricula": 179946897
      },
      {
        "igreja": "Alto Do Canuto",
        "contrato": 7035589125,
        "matricula": 149458169
      },
      {
        "igreja": "Alto Do Papagaio",
        "contrato": 225246556,
        "matricula": 97078930
      },
      {
        "igreja": "Alto Do Paraiso",
        "contrato": 222781060,
        "matricula": 178218235
      },
      {
        "igreja": "Alto Do Quijingue",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Alto Do Santo Antonio",
        "contrato": 212250317,
        "matricula": 51010046
      },
      {
        "igreja": "Alto Do Sobradinho",
        "contrato": 7036767485,
        "matricula": 51098040
      },
      {
        "igreja": "Alvorada",
        "contrato": 7014537109,
        "matricula": ""
      },
      {
        "igreja": "Amargosa",
        "contrato": 7023644112,
        "matricula": 57088721
      },
      {
        "igreja": "Amelia Rodrigues",
        "contrato": 23478382,
        "matricula": ""
      },
      {
        "igreja": "Andarai",
        "contrato": 18790084,
        "matricula": 54654783
      },
      {
        "igreja": "Anguera",
        "contrato": 28552017,
        "matricula": 77856449
      },
      {
        "igreja": "Antas",
        "contrato": 28041977,
        "matricula": 67077021
      },
      {
        "igreja": "Antonio Conselheiro",
        "contrato": 7027287608,
        "matricula": ""
      },
      {
        "igreja": "Apora",
        "contrato": 7021390180,
        "matricula": 72082321
      },
      {
        "igreja": "Araca",
        "contrato": 215733645,
        "matricula": 75862832
      },
      {
        "igreja": "Araci - Sede",
        "contrato": 7024706332,
        "matricula": 85124087
      },
      {
        "igreja": "Aramari",
        "contrato": 220777901,
        "matricula": 78985102
      },
      {
        "igreja": "Arapua - Coqueiro",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Arapua",
        "contrato": "",
        "matricula": 217432065
      },
      {
        "igreja": "Aratuipe",
        "contrato": 214688611,
        "matricula": 68880111
      },
      {
        "igreja": "Asa Branca",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Assembleia",
        "contrato": 209138182,
        "matricula": 54589410
      },
      {
        "igreja": "Av. Airton Sena",
        "contrato": 7036758087,
        "matricula": "SAAE-36808-4"
      },
      {
        "igreja": "Avenida E Silva Brito",
        "contrato": 22285173,
        "matricula": 57629250
      },
      {
        "igreja": "Bairro da Estacao",
        "contrato": 7034864610,
        "matricula": 81319100
      },
      {
        "igreja": "Bairro da Santa",
        "contrato": 220511111,
        "matricula": 181360543
      },
      {
        "igreja": "Bairro Sao Bento",
        "contrato": 228005436,
        "matricula": 100325335
      },
      {
        "igreja": "Baixa Alegre",
        "contrato": 7036776565,
        "matricula": "SAAE-91962-4"
      },
      {
        "igreja": "Baixa do Tanque",
        "contrato": 7048582731,
        "matricula": ""
      },
      {
        "igreja": "Baixa Grande",
        "contrato": 220803708,
        "matricula": ""
      },
      {
        "igreja": "Baixa Grande - Cruz das Almas",
        "contrato": 7034490192,
        "matricula": ""
      },
      {
        "igreja": "Baixao",
        "contrato": 7035296284,
        "matricula": ""
      },
      {
        "igreja": "Baixao Do Guai",
        "contrato": 7002747531,
        "matricula": ""
      },
      {
        "igreja": "Banzae",
        "contrato": 30741064,
        "matricula": 147029112
      },
      {
        "igreja": "Baraunas",
        "contrato": 5611768,
        "matricula": 96845708
      },
      {
        "igreja": "Barra do tanque",
        "contrato": 7045569637,
        "matricula": ""
      },
      {
        "igreja": "Barreiro",
        "contrato": 29344892,
        "matricula": 145962245
      },
      {
        "igreja": "Barreiros",
        "contrato": 7026262148,
        "matricula": 90533399
      },
      {
        "igreja": "Barriguda",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Barrocao II",
        "contrato": 7035939738,
        "matricula": 148748694
      },
      {
        "igreja": "Barrocas",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Bela Vista",
        "contrato": 218192904,
        "matricula": ""
      },
      {
        "igreja": "Bela Vista - Araci",
        "contrato": 7031853855,
        "matricula": ""
      },
      {
        "igreja": "Bela Vista - Serrinha",
        "contrato": 7037394879,
        "matricula": ""
      },
      {
        "igreja": "Belem",
        "contrato": 34851417,
        "matricula": 83891749
      },
      {
        "igreja": "Benone Rezende",
        "contrato": 7029428900,
        "matricula": ""
      },
      {
        "igreja": "Biritinga",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Boa Esperanca",
        "contrato": 7014053314,
        "matricula": ""
      },
      {
        "igreja": "Boa Uniao",
        "contrato": 7042334329,
        "matricula": "SAAE-31407-0"
      },
      {
        "igreja": "Boa Vista",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Boa Vista de Belem",
        "contrato": 7020896455,
        "matricula": ""
      },
      {
        "igreja": "Boa Vista Do Tupim",
        "contrato": 220539997,
        "matricula": 81938330
      },
      {
        "igreja": "Boa Vista - Serrinha",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Boa Vista",
        "contrato": 7026948040,
        "matricula": 142955256
      },
      {
        "igreja": "Boca da Mata",
        "contrato": 201419700,
        "matricula": 180616374
      },
      {
        "igreja": "Boi Peba",
        "contrato": 7039876420,
        "matricula": 179498754
      },
      {
        "igreja": "Bolivia",
        "contrato": 7036776891,
        "matricula": "SAAE-207961-5"
      },
      {
        "igreja": "Bolivia II",
        "contrato": 7022154758,
        "matricula": "SAAE-280358-5"
      },
      {
        "igreja": "Bombinha",
        "contrato": 218551513,
        "matricula": 85168530
      },
      {
        "igreja": "Bonfim",
        "contrato": 30393716,
        "matricula": "SAAE-161628-5"
      },
      {
        "igreja": "Brasilia/Feira",
        "contrato": 7038688272,
        "matricula": 96386142
      },
      {
        "igreja": "Bravo",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Brejo Do Meio",
        "contrato": 225325740,
        "matricula": ""
      },
      {
        "igreja": "Btn I",
        "contrato": 211387440,
        "matricula": 49355660
      },
      {
        "igreja": "Btn III",
        "contrato": 7030099731,
        "matricula": 178953164
      },
      {
        "igreja": "Buril",
        "contrato": 7038687349,
        "matricula": ""
      },
      {
        "igreja": "Cabaceira Paraguacu",
        "contrato": 223458262,
        "matricula": 101219024
      },
      {
        "igreja": "Cachoeira",
        "contrato": 7036777766,
        "matricula": 75395614
      },
      {
        "igreja": "Cachoeira II",
        "contrato": "",
        "matricula": 75404761
      },
      {
        "igreja": "Caimbe",
        "contrato": 59790822,
        "matricula": 212785075
      },
      {
        "igreja": "Caldas de Cipo",
        "contrato": 7020069729,
        "matricula": 62240811
      },
      {
        "igreja": "Caldas Do Jorro",
        "contrato": 22705709,
        "matricula": 83132090
      },
      {
        "igreja": "Caldeirao",
        "contrato": 7003908660,
        "matricula": ""
      },
      {
        "igreja": "Caldeirao Novo",
        "contrato": 202900534,
        "matricula": ""
      },
      {
        "igreja": "Campo Do Gado",
        "contrato": 7041152405,
        "matricula": 97781797
      },
      {
        "igreja": "Campo Limpo",
        "contrato": 7036770761,
        "matricula": 96901527
      },
      {
        "igreja": "Campo Limpo II",
        "contrato": 7038063329,
        "matricula": 177859016
      },
      {
        "igreja": "Cana Brava",
        "contrato": 35281258,
        "matricula": ""
      },
      {
        "igreja": "Cana Brava - Itaberaba",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Candeal",
        "contrato": 7027997176,
        "matricula": 62536958
      },
      {
        "igreja": "Candeal - Itaberaba",
        "contrato": 7013464086,
        "matricula": ""
      },
      {
        "igreja": "Canudos",
        "contrato": 7043680476,
        "matricula": 80286771
      },
      {
        "igreja": "Capanema",
        "contrato": 7040286068,
        "matricula": ""
      },
      {
        "igreja": "Capela Alto Alegre-a",
        "contrato": 7027370009,
        "matricula": 90696123
      },
      {
        "igreja": "Capoeirucu Sede",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Capoeirucu II",
        "contrato": 7036768007,
        "matricula": 79505953
      },
      {
        "igreja": "Cardam",
        "contrato": 7034829025,
        "matricula": ""
      },
      {
        "igreja": "Carnaiba",
        "contrato": 210569154,
        "matricula": 149484194
      },
      {
        "igreja": "Casas Populares",
        "contrato": 7036762149,
        "matricula": 88792056
      },
      {
        "igreja": "Casas Populares 2",
        "contrato": 7035174618,
        "matricula": 177918004
      },
      {
        "igreja": "Cascalheira",
        "contrato": 7018489028,
        "matricula": ""
      },
      {
        "igreja": "Caseb",
        "contrato": 20613017,
        "matricula": 96590483
      },
      {
        "igreja": "Castro Alves",
        "contrato": 16904392,
        "matricula": 77933141
      },
      {
        "igreja": "Castro Alves II",
        "contrato": 229029207,
        "matricula": 77976201
      },
      {
        "igreja": "Catende Azul",
        "contrato": 223600743,
        "matricula": ""
      },
      {
        "igreja": "Catu Grande",
        "contrato": 7037726650,
        "matricula": ""
      },
      {
        "igreja": "Caxias",
        "contrato": 11669727,
        "matricula": 89120396
      },
      {
        "igreja": "Celao",
        "contrato": 7036761185,
        "matricula": ""
      },
      {
        "igreja": "Centenario",
        "contrato": 7043506573,
        "matricula": ""
      },
      {
        "igreja": "Chesf",
        "contrato": 7017537509,
        "matricula": 49389076
      },
      {
        "igreja": "Cicero Dantas",
        "contrato": 207921726,
        "matricula": 66195152
      },
      {
        "igreja": "Cidade de Deus",
        "contrato": 7001657717,
        "matricula": ""
      },
      {
        "igreja": "Cidade Nova",
        "contrato": 7045153791,
        "matricula": 53672399
      },
      {
        "igreja": "Cidade Nova Sede",
        "contrato": 10771714,
        "matricula": 96864273
      },
      {
        "igreja": "Cidade Nova - Inhambupe",
        "contrato": 7026434941,
        "matricula": 63084392
      },
      {
        "igreja": "Cipoal",
        "contrato": 7028902900,
        "matricula": 67699758
      },
      {
        "igreja": "Coite II",
        "contrato": 7037426045,
        "matricula": ""
      },
      {
        "igreja": "Colina das Mangueiras",
        "contrato": 7013342827,
        "matricula": 53662636
      },
      {
        "igreja": "Colonia",
        "contrato": 7013900030,
        "matricula": ""
      },
      {
        "igreja": "Colonia Nova",
        "contrato": 28366698,
        "matricula": ""
      },
      {
        "igreja": "Colonia Velha",
        "contrato": 31319366,
        "matricula": 31319366
      },
      {
        "igreja": "Conceicao da Feira",
        "contrato": 4331990,
        "matricula": 62493213
      },
      {
        "igreja": "Conceicao Do Almeida",
        "contrato": "",
        "matricula": 64197980
      },
      {
        "igreja": "Conceicao Do Coite Sede",
        "contrato": 7045153805,
        "matricula": ""
      },
      {
        "igreja": "Conceicao Do Jacuipe",
        "contrato": 15950382,
        "matricula": 70730172
      },
      {
        "igreja": "Conceicao I",
        "contrato": 230901988,
        "matricula": 98168681
      },
      {
        "igreja": "Conceicao II",
        "contrato": 23377845,
        "matricula": 97026921
      },
      {
        "igreja": "Conjunto Jose Ronaldo",
        "contrato": 7009695634,
        "matricula": 98060422
      },
      {
        "igreja": "Coplan",
        "contrato": 214267993,
        "matricula": 54604770
      },
      {
        "igreja": "Coqueiro",
        "contrato": 7039412470,
        "matricula": 85140333
      },
      {
        "igreja": "Coqueiro II",
        "contrato": 7025251460,
        "matricula": 85196312
      },
      {
        "igreja": "Coracao de Maria",
        "contrato": 201706866,
        "matricula": 89544838
      },
      {
        "igreja": "Coreia - Cicero Dantas",
        "contrato": 221862171,
        "matricula": 66195349
      },
      {
        "igreja": "Coreia",
        "contrato": 7031482296,
        "matricula": ""
      },
      {
        "igreja": "Coronel Vincente",
        "contrato": 7008286315,
        "matricula": 75771322
      },
      {
        "igreja": "Crenguenhem Grupo",
        "contrato": 7014481901,
        "matricula": ""
      },
      {
        "igreja": "Crisopolis",
        "contrato": 18818590,
        "matricula": 71834583
      },
      {
        "igreja": "Cruz das Almas",
        "contrato": 7045107889,
        "matricula": 54489741
      },
      {
        "igreja": "Cruzeiro",
        "contrato": 7020983625,
        "matricula": ""
      },
      {
        "igreja": "Curral Falso",
        "contrato": 11026958,
        "matricula": 148822320
      },
      {
        "igreja": "Curral Velho",
        "contrato": 7009115409,
        "matricula": ""
      },
      {
        "igreja": "Dona Maria",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Dona Rosa",
        "contrato": 28243758,
        "matricula": 54521408
      },
      {
        "igreja": "Duque de Caxias",
        "contrato": 7028371203,
        "matricula": ""
      },
      {
        "igreja": "Elisio Medrado",
        "contrato": 220194744,
        "matricula": ""
      },
      {
        "igreja": "Embira",
        "contrato": 7042336402,
        "matricula": 180533053
      },
      {
        "igreja": "Encruzilhada Valente",
        "contrato": 31761581,
        "matricula": 65691601
      },
      {
        "igreja": "Encruzilhada 2",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Encruzo",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Encruzo II",
        "contrato": 218060714,
        "matricula": 179886622
      },
      {
        "igreja": "Entrada da Pedra",
        "contrato": 7010009523,
        "matricula": 94341850
      },
      {
        "igreja": "Entre Rios",
        "contrato": 2724375,
        "matricula": 79101119
      },
      {
        "igreja": "Entrocamento de Valenca",
        "contrato": 7038834155,
        "matricula": ""
      },
      {
        "igreja": "Entrocamento Satiro Dias",
        "contrato": 28313306,
        "matricula": 179768239
      },
      {
        "igreja": "Entroncamento de Lages",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Esplanada",
        "contrato": 7000537050,
        "matricula": 60822880
      },
      {
        "igreja": "Estacao",
        "contrato": 7039446892,
        "matricula": 60819570
      },
      {
        "igreja": "Estevao",
        "contrato": 7040288761,
        "matricula": "SAAE-61784-5"
      },
      {
        "igreja": "Euclides da Cunha",
        "contrato": 29539510,
        "matricula": 59746351
      },
      {
        "igreja": "Fatima",
        "contrato": 7039927700,
        "matricula": 87955628
      },
      {
        "igreja": "Fazenda Cajarana",
        "contrato": 7037426045,
        "matricula": ""
      },
      {
        "igreja": "Fazenda de Cima",
        "contrato": 7026654127,
        "matricula": 78321999
      },
      {
        "igreja": "Fazenda Diamante",
        "contrato": 7027310952,
        "matricula": ""
      },
      {
        "igreja": "Fazenda do Brejo",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Fazenda Guerra",
        "contrato": 7042826400,
        "matricula": ""
      },
      {
        "igreja": "Fazenda Juazeiro",
        "contrato": 210646116,
        "matricula": 148461441
      },
      {
        "igreja": "Fazenda Mancambira",
        "contrato": 7025906483,
        "matricula": ""
      },
      {
        "igreja": "Fazenda Mercantil",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Fazenda Piau",
        "contrato": 218850464,
        "matricula": ""
      },
      {
        "igreja": "Fazenda Sao Jose",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Fazenda Verdes Campos",
        "contrato": 7040294125,
        "matricula": 179995359
      },
      {
        "igreja": "Feira da Serra",
        "contrato": 7020397297,
        "matricula": ""
      },
      {
        "igreja": "Feira de Santana - Central",
        "contrato": 7020068510,
        "matricula": 96320940
      },
      {
        "igreja": "Feira VI",
        "contrato": 7029144880,
        "matricula": 97698040
      },
      {
        "igreja": "Feira VII",
        "contrato": 7005801804,
        "matricula": ""
      },
      {
        "igreja": "Feira X",
        "contrato": 17206486,
        "matricula": 96488430
      },
      {
        "igreja": "Feira X 2",
        "contrato": "",
        "matricula": 96507276
      },
      {
        "igreja": "Felicidade",
        "contrato": 7036759202,
        "matricula": 85185965
      },
      {
        "igreja": "Formiga II",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Fraternidade",
        "contrato": 7038688590,
        "matricula": ""
      },
      {
        "igreja": "Frei Apolonio",
        "contrato": 7003332963,
        "matricula": 89151925
      },
      {
        "igreja": "Funcionarios Publicos",
        "contrato": 7045822510,
        "matricula": 79154328
      },
      {
        "igreja": "Furtado",
        "contrato": 7019218575,
        "matricula": ""
      },
      {
        "igreja": "Gabriela",
        "contrato": 7021781260,
        "matricula": 98447645
      },
      {
        "igreja": "Gameleira",
        "contrato": 7020692078,
        "matricula": ""
      },
      {
        "igreja": "Gaviao I",
        "contrato": 2530821,
        "matricula": 88835014
      },
      {
        "igreja": "Gaviao II",
        "contrato": 33177119,
        "matricula": 179682253
      },
      {
        "igreja": "Gaviao III",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Genipapo",
        "contrato": 7041164934,
        "matricula": ""
      },
      {
        "igreja": "Geolandia",
        "contrato": 18997894,
        "matricula": 101262760
      },
      {
        "igreja": "George Americo",
        "contrato": 23157292,
        "matricula": 97606898
      },
      {
        "igreja": "Gereba",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Getulio Vargas",
        "contrato": 222865816,
        "matricula": 65260546
      },
      {
        "igreja": "Gitirana Grupo",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Gloria",
        "contrato": 7047689249,
        "matricula": 85838934
      },
      {
        "igreja": "Goiabeira",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Governador Mangabeira",
        "contrato": 10154863,
        "matricula": 67677398
      },
      {
        "igreja": "Gravata",
        "contrato": 7027213620,
        "matricula": ""
      },
      {
        "igreja": "Grupo da Prainha",
        "contrato": 49106031,
        "matricula": ""
      },
      {
        "igreja": "Guaibim",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Guanabara",
        "contrato": 7030751811,
        "matricula": ""
      },
      {
        "igreja": "Guaracu",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Guarani",
        "contrato": 7045153872,
        "matricula": 85187690
      },
      {
        "igreja": "Heliopolis",
        "contrato": 11022286,
        "matricula": 88023516
      },
      {
        "igreja": "Heliopolis II",
        "contrato": 7037539400,
        "matricula": ""
      },
      {
        "igreja": "Hildete Lomanto",
        "contrato": 7035905795,
        "matricula": 57647739
      },
      {
        "igreja": "Humildes",
        "contrato": 227931922,
        "matricula": 84205628
      },
      {
        "igreja": "Iacu",
        "contrato": 7043682681,
        "matricula": 65231104
      },
      {
        "igreja": "Ibatui",
        "contrato": 7015923142,
        "matricula": ""
      },
      {
        "igreja": "Ibo",
        "contrato": 7046249822,
        "matricula": 180017586
      },
      {
        "igreja": "Igreja do Campus - FADBA",
        "contrato": 7028902900,
        "matricula": 67699758
      },
      {
        "igreja": "Imbiara",
        "contrato": 7038834155,
        "matricula": ""
      },
      {
        "igreja": "Inhambupe",
        "contrato": 7040285568,
        "matricula": 63757168
      },
      {
        "igreja": "Inocoop",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Ipira",
        "contrato": 7045579560,
        "matricula": 58659536
      },
      {
        "igreja": "Ipuacu",
        "contrato": 3116174,
        "matricula": 100826750
      },
      {
        "igreja": "Irara",
        "contrato": 7032653272,
        "matricula": 178675610
      },
      {
        "igreja": "Irma Dulce",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Itaberaba",
        "contrato": 7036779084,
        "matricula": 51696665
      },
      {
        "igreja": "Itaete",
        "contrato": 204404720,
        "matricula": 82846987
      },
      {
        "igreja": "Itamira",
        "contrato": 24622452,
        "matricula": 100544061
      },
      {
        "igreja": "Itapicuru",
        "contrato": 7034858661,
        "matricula": 178089826
      },
      {
        "igreja": "Itatim",
        "contrato": 7005810331,
        "matricula": 89305671
      },
      {
        "igreja": "Jacare",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Jacu",
        "contrato": 231498516,
        "matricula": 85189979
      },
      {
        "igreja": "Jambeiro",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Jardim Acacia",
        "contrato": 218004482,
        "matricula": 98038729
      },
      {
        "igreja": "Jardim America",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Jardim America - Tomba",
        "contrato": 7039538029,
        "matricula": 179526308
      },
      {
        "igreja": "Jardim Bahia",
        "contrato": 7036778118,
        "matricula": 49209124
      },
      {
        "igreja": "Jardim Cruzeiro",
        "contrato": 7042798236,
        "matricula": 96748672
      },
      {
        "igreja": "Jardim Cruzeiro 2",
        "contrato": 220316459,
        "matricula": 97542750
      },
      {
        "igreja": "Jardim das Palmeiras",
        "contrato": 7021823222,
        "matricula": 51838508
      },
      {
        "igreja": "Jardim Maravilha",
        "contrato": 7029144030,
        "matricula": 177264110
      },
      {
        "igreja": "Jenipapo - Inhambupe",
        "contrato": 7037581300,
        "matricula": ""
      },
      {
        "igreja": "Jenipapo",
        "contrato": 214876914,
        "matricula": 149420684
      },
      {
        "igreja": "Jequie Mirim",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Jequirica",
        "contrato": 12234082,
        "matricula": 75777487
      },
      {
        "igreja": "Jeremoabo",
        "contrato": 7039536654,
        "matricula": 64477380
      },
      {
        "igreja": "Joao Amaro",
        "contrato": 230599343,
        "matricula": 81305885
      },
      {
        "igreja": "Joao Paulo II - Cidade Nova",
        "contrato": 7036779920,
        "matricula": 97707090
      },
      {
        "igreja": "Joao Vieira",
        "contrato": 204854670,
        "matricula": ""
      },
      {
        "igreja": "Jorrinho",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "",
        "contrato": "",
        "matricula": 96578661
      },
      {
        "igreja": "Kauanga",
        "contrato": 7036778282,
        "matricula": ""
      },
      {
        "igreja": "Km 100",
        "contrato": 7020647188,
        "matricula": 147785324
      },
      {
        "igreja": "Km 135",
        "contrato": 7037965949,
        "matricula": 96174382
      },
      {
        "igreja": "Km 18",
        "contrato": 228840785,
        "matricula": "SAAE-49677-8"
      },
      {
        "igreja": "Km 25",
        "contrato": 7040917491,
        "matricula": ""
      },
      {
        "igreja": "Km 37",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Km 6",
        "contrato": 214549700,
        "matricula": ""
      },
      {
        "igreja": "Km 82",
        "contrato": 211143665,
        "matricula": ""
      },
      {
        "igreja": "Lages",
        "contrato": 7017273617,
        "matricula": ""
      },
      {
        "igreja": "Lagoa da Jurema Grupo",
        "contrato": 7017044707,
        "matricula": ""
      },
      {
        "igreja": "Lagoa da Picada",
        "contrato": 7004971420,
        "matricula": ""
      },
      {
        "igreja": "Lagoa da Pumba",
        "contrato": 7037895061,
        "matricula": ""
      },
      {
        "igreja": "Lagoa Do Boi",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Lagoa Do Cupan",
        "contrato": 7002959563,
        "matricula": ""
      },
      {
        "igreja": "Lagoa Do Mato",
        "contrato": 20774509,
        "matricula": ""
      },
      {
        "igreja": "Lagoa do Ramo",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Lagoa Fechada",
        "contrato": 7029640992,
        "matricula": 161659373
      },
      {
        "igreja": "Lagoa Grande",
        "contrato": 7029145266,
        "matricula": 96682043
      },
      {
        "igreja": "Lagoa I",
        "contrato": 7006027568,
        "matricula": ""
      },
      {
        "igreja": "Lagoa Salgada",
        "contrato": 200828640,
        "matricula": 97316342
      },
      {
        "igreja": "Lagoeta",
        "contrato": 7039936245,
        "matricula": 179811495
      },
      {
        "igreja": "Lagoinha das Pedras",
        "contrato": 7001260191,
        "matricula": 88585964
      },
      {
        "igreja": "Limeira",
        "contrato": 7036860146,
        "matricula": 97781797
      },
      {
        "igreja": "limoeiro",
        "contrato": 7051687110,
        "matricula": 62504878
      },
      {
        "igreja": "Lisboa",
        "contrato": 230053111,
        "matricula": 54617103
      },
      {
        "igreja": "Lot. Raimundo Guimaraes",
        "contrato": 63255499,
        "matricula": 63255499
      },
      {
        "igreja": "Loteamento Primavera",
        "contrato": "SULGIPE-151156/4",
        "matricula": 63274809
      },
      {
        "igreja": "Loteamento Santa Rita",
        "contrato": "SULGIPE-84908/1",
        "matricula": ""
      },
      {
        "igreja": "Luciano Barreto",
        "contrato": 29004854,
        "matricula": 97921726
      },
      {
        "igreja": "Macaubas",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Magalhaes",
        "contrato": 7028444960,
        "matricula": 100709036
      },
      {
        "igreja": "Malombe",
        "contrato": 7013126016,
        "matricula": ""
      },
      {
        "igreja": "Malvinas",
        "contrato": 21668052,
        "matricula": 60799854
      },
      {
        "igreja": "Mangabeira",
        "contrato": 7031631828,
        "matricula": 97200182
      },
      {
        "igreja": "Mangabeira - Irara",
        "contrato": 7032653272,
        "matricula": 178675610
      },
      {
        "igreja": "Mangalo",
        "contrato": 7020214265,
        "matricula": "SAAE-31011-0"
      },
      {
        "igreja": "Mangalo II",
        "contrato": 7014751429,
        "matricula": "SAAE-53032-9"
      },
      {
        "igreja": "Manoel Vitorino",
        "contrato": 7045153481,
        "matricula": "SAAE-58990-3"
      },
      {
        "igreja": "Maragojipe",
        "contrato": 852171,
        "matricula": 54235740
      },
      {
        "igreja": "Maranco",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Marcionilio Souza",
        "contrato": "",
        "matricula": 81557426
      },
      {
        "igreja": "Maria Quiteria",
        "contrato": 7022276667,
        "matricula": 96578661
      },
      {
        "igreja": "Marieta Ferraz",
        "contrato": 23078171,
        "matricula": 97793582
      },
      {
        "igreja": "Matinha",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Meio de Campo",
        "contrato": 7041060942,
        "matricula": ""
      },
      {
        "igreja": "Merces",
        "contrato": 35730877,
        "matricula": ""
      },
      {
        "igreja": "Milagres",
        "contrato": 7024997868,
        "matricula": 89404475
      },
      {
        "igreja": "Miradouro",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Monte alamo",
        "contrato": 7039755925,
        "matricula": ""
      },
      {
        "igreja": "Monte Belo",
        "contrato": 7024648995,
        "matricula": 58730796
      },
      {
        "igreja": "Monte Castelo",
        "contrato": 35192832,
        "matricula": 54234735
      },
      {
        "igreja": "Moria",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Morro de Sao Paulo",
        "contrato": 7048581816,
        "matricula": 95817115
      },
      {
        "igreja": "Moxoto",
        "contrato": 7017539404,
        "matricula": 49382314
      },
      {
        "igreja": "Mucambinho de Limeira",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Mulungu - Ribeira Do Pompal",
        "contrato": 213105043,
        "matricula": ""
      },
      {
        "igreja": "Mulungu",
        "contrato": 7043756243,
        "matricula": ""
      },
      {
        "igreja": "Municipio",
        "contrato": 226648585,
        "matricula": 85188042
      },
      {
        "igreja": "Murilo Leite",
        "contrato": 7014847329,
        "matricula": 60154705
      },
      {
        "igreja": "Muringue",
        "contrato": 230075590,
        "matricula": ""
      },
      {
        "igreja": "Muriti",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Muritiba",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Muritiba II",
        "contrato": 7004967369,
        "matricula": 59978562
      },
      {
        "igreja": "Muritibinha",
        "contrato": 213975099,
        "matricula": ""
      },
      {
        "igreja": "Murutuba",
        "contrato": 7028352870,
        "matricula": ""
      },
      {
        "igreja": "Mutirao",
        "contrato": "",
        "matricula": 179072285
      },
      {
        "igreja": "Mutuipe",
        "contrato": 215733645,
        "matricula": 75862832
      },
      {
        "igreja": "Nage",
        "contrato": 7045579071,
        "matricula": 81518170
      },
      {
        "igreja": "Nazare das Farinhas",
        "contrato": 7040798026,
        "matricula": 54026598
      },
      {
        "igreja": "Nazare das Farinhas II",
        "contrato": 7043779332,
        "matricula": 54053013
      },
      {
        "igreja": "Nova America",
        "contrato": 7023786820,
        "matricula": 59830328
      },
      {
        "igreja": "Nova Brasilia",
        "contrato": 230853053,
        "matricula": 70792585
      },
      {
        "igreja": "Nova Brasilia - 21 de Setembro",
        "contrato": 7027750227,
        "matricula": "SAAE-53417-2"
      },
      {
        "igreja": "Nova Canaa",
        "contrato": 7041075982,
        "matricula": ""
      },
      {
        "igreja": "Nova Cipo",
        "contrato": 7032323256,
        "matricula": 62256220
      },
      {
        "igreja": "Nova Esperanca - Hildete",
        "contrato": 232364211,
        "matricula": 148784194
      },
      {
        "igreja": "Nova Esperanca - Cachoeira",
        "contrato": 7037635434,
        "matricula": 178161489
      },
      {
        "igreja": "Nova Esperanca",
        "contrato": 221133870,
        "matricula": ""
      },
      {
        "igreja": "Nova Fatima",
        "contrato": 7023350240,
        "matricula": 88782425
      },
      {
        "igreja": "Nova Jerusalem",
        "contrato": 7045153902,
        "matricula": ""
      },
      {
        "igreja": "Nova Minacao",
        "contrato": 204920303,
        "matricula": ""
      },
      {
        "igreja": "Nova Pastora",
        "contrato": 27504019,
        "matricula": 142855880
      },
      {
        "igreja": "Nova Soure",
        "contrato": 7038686792,
        "matricula": 62677063
      },
      {
        "igreja": "Novo Horizonte - Valenca",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Novo Horizonte",
        "contrato": "",
        "matricula": 97793582
      },
      {
        "igreja": "Novo Horizonte - Alagoinhas",
        "contrato": 214651068,
        "matricula": "SAAE-35879-6"
      },
      {
        "igreja": "Novo Inhambupe",
        "contrato": 7012248649,
        "matricula": ""
      },
      {
        "igreja": "Novo Triunfo",
        "contrato": 223193919,
        "matricula": 81624026
      },
      {
        "igreja": "Olindina",
        "contrato": 24447251,
        "matricula": ""
      },
      {
        "igreja": "Orobo",
        "contrato": 7024564880,
        "matricula": ""
      },
      {
        "igreja": "Ouro verde",
        "contrato": 7034462393,
        "matricula": 178034941
      },
      {
        "igreja": "Panorama",
        "contrato": 23588323,
        "matricula": 97152420
      },
      {
        "igreja": "Paraguacu",
        "contrato": 202797148,
        "matricula": ""
      },
      {
        "igreja": "Parque Getulio Vargas",
        "contrato": 7036773124,
        "matricula": 96632844
      },
      {
        "igreja": "Parque Ipe",
        "contrato": 23082691,
        "matricula": 97714569
      },
      {
        "igreja": "Parque Sabia",
        "contrato": 7023314201,
        "matricula": 97712930
      },
      {
        "igreja": "Parque Sao Bernardo",
        "contrato": 7015938689,
        "matricula": "SAAE-31199-3"
      },
      {
        "igreja": "Parque Servilha",
        "contrato": 231502076,
        "matricula": ""
      },
      {
        "igreja": "Pau Ferro/Inhambupe",
        "contrato": 7037836604,
        "matricula": 178113468
      },
      {
        "igreja": "Paulo Afonso",
        "contrato": 7042700732,
        "matricula": 49004697
      },
      {
        "igreja": "Pe de serra",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Pe de Serra - Nova Fatima",
        "contrato": 7031429867,
        "matricula": 90497473
      },
      {
        "igreja": "Pe de Serra - Inhambupe",
        "contrato": 7028409260,
        "matricula": 72058366
      },
      {
        "igreja": "Pedra",
        "contrato": 7024405537,
        "matricula": 92263909
      },
      {
        "igreja": "Pedra Ferrada",
        "contrato": 7036775020,
        "matricula": ""
      },
      {
        "igreja": "Pedra Ferrada II",
        "contrato": 7039133819,
        "matricula": ""
      },
      {
        "igreja": "Pedra Vermelha",
        "contrato": 7015772624,
        "matricula": ""
      },
      {
        "igreja": "Pedras Altas",
        "contrato": 7006088290,
        "matricula": ""
      },
      {
        "igreja": "Pedras - Tucano",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Pedro Alexandre",
        "contrato": 7032924950,
        "matricula": 177813091
      },
      {
        "igreja": "Pedro Tibucio",
        "contrato": 7038688027,
        "matricula": 57678260
      },
      {
        "igreja": "Petim",
        "contrato": 229433199,
        "matricula": ""
      },
      {
        "igreja": "Petrolar",
        "contrato": 7043013496,
        "matricula": "SAAE-36935-5"
      },
      {
        "igreja": "Picado",
        "contrato": 7020852890,
        "matricula": ""
      },
      {
        "igreja": "Pindoba",
        "contrato": 227292580,
        "matricula": 75790297
      },
      {
        "igreja": "Pinheiro",
        "contrato": 177432837,
        "matricula": 7010795057
      },
      {
        "igreja": "Poco Gameleira",
        "contrato": 7042363205,
        "matricula": ""
      },
      {
        "igreja": "Pombalzinho",
        "contrato": 24258254,
        "matricula": 57639647
      },
      {
        "igreja": "Ponto Central",
        "contrato": "",
        "matricula": 9656110
      },
      {
        "igreja": "Populares",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Portao",
        "contrato": 228328901,
        "matricula": 67697550
      },
      {
        "igreja": "Porto Maragojipe",
        "contrato": "",
        "matricula": 54260485
      },
      {
        "igreja": "Posto Aguia",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Posto Aguia II",
        "contrato": "",
        "matricula": 67698468
      },
      {
        "igreja": "Povoado Araujo",
        "contrato": 7038895375,
        "matricula": ""
      },
      {
        "igreja": "Povoado Aroeira",
        "contrato": 7022819326,
        "matricula": 177532963
      },
      {
        "igreja": "Povoado de Barreiras",
        "contrato": 7040461897,
        "matricula": ""
      },
      {
        "igreja": "Povoado Jua",
        "contrato": 22148060,
        "matricula": 166170232
      },
      {
        "igreja": "Povoado Serra Branca",
        "contrato": 7044751199,
        "matricula": 85199176
      },
      {
        "igreja": "Pumba I",
        "contrato": 222501610,
        "matricula": 54668859
      },
      {
        "igreja": "Queimada Do Borges",
        "contrato": 231088733,
        "matricula": 61353701
      },
      {
        "igreja": "Queimadas",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Queimadinha",
        "contrato": 7036771237,
        "matricula": 98011448
      },
      {
        "igreja": "Quijingue",
        "contrato": 2000226364,
        "matricula": 72001100
      },
      {
        "igreja": "Quijingue II",
        "contrato": 7043247675,
        "matricula": 177262974
      },
      {
        "igreja": "Quixaba",
        "contrato": 7048581328,
        "matricula": ""
      },
      {
        "igreja": "Quizanga",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Raspador",
        "contrato": 16691666,
        "matricula": ""
      },
      {
        "igreja": "Recanto Paraguacu",
        "contrato": 7021876113,
        "matricula": 62556185
      },
      {
        "igreja": "Remedios",
        "contrato": 33891440,
        "matricula": 54062683
      },
      {
        "igreja": "Renascer",
        "contrato": 207338761,
        "matricula": 97978019
      },
      {
        "igreja": "Retiro",
        "contrato": 7044657222,
        "matricula": ""
      },
      {
        "igreja": "Retirolandia",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Riachao Do Jacuipe",
        "contrato": 7038833957,
        "matricula": 61353701
      },
      {
        "igreja": "Riacho Do Boi",
        "contrato": 224973491,
        "matricula": ""
      },
      {
        "igreja": "Ribeira - Araci",
        "contrato": 7036759580,
        "matricula": ""
      },
      {
        "igreja": "Ribeira Do Amparo",
        "contrato": 200235282,
        "matricula": ""
      },
      {
        "igreja": "Ribeira Do Pombal",
        "contrato": 7020650448,
        "matricula": 57587019
      },
      {
        "igreja": "Ribeira II",
        "contrato": 217022355,
        "matricula": ""
      },
      {
        "igreja": "Rio das Pedras",
        "contrato": 14939180,
        "matricula": ""
      },
      {
        "igreja": "Rio Do Peixe - Coqueiro",
        "contrato": 7045153902,
        "matricula": ""
      },
      {
        "igreja": "Rio Do Peixe",
        "contrato": "",
        "matricula": 163897026
      },
      {
        "igreja": "Rio Real",
        "contrato": "SULGIPE-30022/5",
        "matricula": 63188333
      },
      {
        "igreja": "Rua Camacari",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Rua da Palha",
        "contrato": 214098687,
        "matricula": ""
      },
      {
        "igreja": "Rua Do Catu",
        "contrato": 7038724996,
        "matricula": "SAAE- 58996-0"
      },
      {
        "igreja": "Rua Nova",
        "contrato": 236000765,
        "matricula": 96739762
      },
      {
        "igreja": "Rui Barbosa",
        "contrato": 211794445,
        "matricula": 58446923
      },
      {
        "igreja": "Rui Barbosa-a",
        "contrato": "SULGIPE-117584/0",
        "matricula": 63244152
      },
      {
        "igreja": "Sacramento-a",
        "contrato": 202488951,
        "matricula": 94246475
      },
      {
        "igreja": "Salgadalia",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Salgadeira",
        "contrato": "SULGIPE-181503/2",
        "matricula": ""
      },
      {
        "igreja": "Salgado",
        "contrato": 231087702,
        "matricula": ""
      },
      {
        "igreja": "Samambaia",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Santa Barbara",
        "contrato": 22446037,
        "matricula": 88387895
      },
      {
        "igreja": "Santa Brigida",
        "contrato": 210937536,
        "matricula": 74255177
      },
      {
        "igreja": "Santa Luz",
        "contrato": 274321,
        "matricula": 92463177
      },
      {
        "igreja": "Santa Monica - Sede",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Santa Rita de Cassia",
        "contrato": 7036762670,
        "matricula": 100921094
      },
      {
        "igreja": "Santa Terezinha",
        "contrato": 25114540,
        "matricula": "SAAE-11433-0"
      },
      {
        "igreja": "Santa Terezinha-a",
        "contrato": 7026095780,
        "matricula": 89233450
      },
      {
        "igreja": "Santo Amaro da Purificacao",
        "contrato": 15103795,
        "matricula": 94277770
      },
      {
        "igreja": "Santo Antonio",
        "contrato": 18268531,
        "matricula": 90312295
      },
      {
        "igreja": "Santo Antonio de Jesus",
        "contrato": 7026482997,
        "matricula": 51049147
      },
      {
        "igreja": "Santo Antonio dos Prazeres",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Santo Estevao",
        "contrato": 7022012830,
        "matricula": 70449279
      },
      {
        "igreja": "Santuario 200",
        "contrato": 7045153660,
        "matricula": ""
      },
      {
        "igreja": "Sao Benedito",
        "contrato": 219525672,
        "matricula": ""
      },
      {
        "igreja": "Sao Bento",
        "contrato": 201444390,
        "matricula": ""
      },
      {
        "igreja": "Sao Cristovao - Feira",
        "contrato": 211070587,
        "matricula": 148056210
      },
      {
        "igreja": "Sao Domingos",
        "contrato": 7036763161,
        "matricula": 77349962
      },
      {
        "igreja": "Sao Felipe",
        "contrato": 20377718,
        "matricula": 66366402
      },
      {
        "igreja": "Sao Felix",
        "contrato": 7029146246,
        "matricula": 96167610
      },
      {
        "igreja": "Sao Goncalo dos Campos",
        "contrato": 7025876541,
        "matricula": 60155000
      },
      {
        "igreja": "Sao Joao",
        "contrato": 228569798,
        "matricula": 96133217
      },
      {
        "igreja": "Sao Jose Do Itapora",
        "contrato": 7031483373,
        "matricula": 54518747
      },
      {
        "igreja": "Sao Miguel das Matas",
        "contrato": 7036774384,
        "matricula": 81271522
      },
      {
        "igreja": "Sapeacu",
        "contrato": 202247130,
        "matricula": 68057563
      },
      {
        "igreja": "Sapucaia",
        "contrato": 20143908,
        "matricula": 72090910
      },
      {
        "igreja": "Satiro Dias",
        "contrato": 7043786274,
        "matricula": 74314300
      },
      {
        "igreja": "Saubara",
        "contrato": 34764530,
        "matricula": 92391877
      },
      {
        "igreja": "Segredo",
        "contrato": 35327622,
        "matricula": ""
      },
      {
        "igreja": "Serra",
        "contrato": 220136523,
        "matricula": 62532820
      },
      {
        "igreja": "Serra Grande - Cicero",
        "contrato": 7032681330,
        "matricula": ""
      },
      {
        "igreja": "Serra Grande",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Serraria II",
        "contrato": 7042251660,
        "matricula": ""
      },
      {
        "igreja": "Serrinha",
        "contrato": 7036430022,
        "matricula": 53543700
      },
      {
        "igreja": "Serrote Do Meio",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Sim",
        "contrato": 7040257270,
        "matricula": 97438804
      },
      {
        "igreja": "Sitio Do Meio",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Sitio Do Quijingue",
        "contrato": 226494880,
        "matricula": 162877536
      },
      {
        "igreja": "Sitio Do Quinto",
        "contrato": 20266058,
        "matricula": 87573652
      },
      {
        "igreja": "Sitio Matias",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Sitio Novo",
        "contrato": 7000168801,
        "matricula": ""
      },
      {
        "igreja": "Sobradinho",
        "contrato": 7036775410,
        "matricula": 97180300
      },
      {
        "igreja": "Sobrado",
        "contrato": 27591396,
        "matricula": 165515023
      },
      {
        "igreja": "Soter Cardoso",
        "contrato": 7045153716,
        "matricula": 167790021
      },
      {
        "igreja": "Suzana",
        "contrato": "",
        "matricula": 54565766
      },
      {
        "igreja": "Tamandari",
        "contrato": 7035359570,
        "matricula": 175154228
      },
      {
        "igreja": "Tancredo Neves",
        "contrato": 7043665841,
        "matricula": 49132270
      },
      {
        "igreja": "Tanque Do Marques",
        "contrato": "SULGIPE-86034/4",
        "matricula": 63265451
      },
      {
        "igreja": "Tanque Do Rumo",
        "contrato": 7007817040,
        "matricula": ""
      },
      {
        "igreja": "Tanquinho",
        "contrato": 7014357810,
        "matricula": 7014357810
      },
      {
        "igreja": "Tanquinho - Conceicao",
        "contrato": 7026654127,
        "matricula": ""
      },
      {
        "igreja": "Tapera-a",
        "contrato": 7043914647,
        "matricula": 167961811
      },
      {
        "igreja": "Taperoa",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Tapuio",
        "contrato": 7024484925,
        "matricula": ""
      },
      {
        "igreja": "Teodoro Sampaio",
        "contrato": 2000226164,
        "matricula": 72001100
      },
      {
        "igreja": "Teofilandia",
        "contrato": 7045579276,
        "matricula": 81901879
      },
      {
        "igreja": "Teresopolis",
        "contrato": 7036765725,
        "matricula": "SAAE-53341-4"
      },
      {
        "igreja": "Terra Branca",
        "contrato": 205600094,
        "matricula": 145076121
      },
      {
        "igreja": "Terra Nova",
        "contrato": 7036770338,
        "matricula": 71921818
      },
      {
        "igreja": "Terra Preta",
        "contrato": 35691413,
        "matricula": ""
      },
      {
        "igreja": "Terra Santa",
        "contrato": 7013571788,
        "matricula": ""
      },
      {
        "igreja": "Tibiri",
        "contrato": 70812488,
        "matricula": ""
      },
      {
        "igreja": "Timbo",
        "contrato": 218054048,
        "matricula": 60821183
      },
      {
        "igreja": "Tomba",
        "contrato": 15360771,
        "matricula": 96434848
      },
      {
        "igreja": "Tororo",
        "contrato": 7039070124,
        "matricula": 75420813
      },
      {
        "igreja": "Touquinha",
        "contrato": "",
        "matricula": 54532493
      },
      {
        "igreja": "Treze de Maio",
        "contrato": 7036764028,
        "matricula": 88787079
      },
      {
        "igreja": "Trindade-a",
        "contrato": 7047689370,
        "matricula": ""
      },
      {
        "igreja": "Tucano",
        "contrato": 230729670,
        "matricula": 66977800
      },
      {
        "igreja": "Tupy Caldas",
        "contrato": 7036758648,
        "matricula": "SAAE-51230-1"
      },
      {
        "igreja": "Uaua",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Una Mirim",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Urbis",
        "contrato": 7007473820,
        "matricula": 179827600
      },
      {
        "igreja": "Urbis III",
        "contrato": 7033378275,
        "matricula": 50947397
      },
      {
        "igreja": "Urbis IV",
        "contrato": "",
        "matricula": 50988417
      },
      {
        "igreja": "Urbis Valenca",
        "contrato": 7036777324,
        "matricula": "SAAE- 72390-8"
      },
      {
        "igreja": "Urbis-Itamira",
        "contrato": 7030767823,
        "matricula": 160710936
      },
      {
        "igreja": "Valenca",
        "contrato": 7030484279,
        "matricula": "SAAE-37471-7"
      },
      {
        "igreja": "Valente",
        "contrato": 7015905691,
        "matricula": 65688414
      },
      {
        "igreja": "Vargem Grande",
        "contrato": 26098068,
        "matricula": ""
      },
      {
        "igreja": "Varginha Grupo",
        "contrato": 7016230159,
        "matricula": 66984602
      },
      {
        "igreja": "Vila Aparecida",
        "contrato": 7030883408,
        "matricula": 169065863
      },
      {
        "igreja": "Vila Canaa",
        "contrato": "",
        "matricula": ""
      },
      {
        "igreja": "Vila Nova",
        "contrato": 7023372171,
        "matricula": ""
      },
      {
        "igreja": "Vila Nova/rio Real",
        "contrato": "SULGIPE-86386/6",
        "matricula": 63247666
      },
      {
        "igreja": "Vila Rica",
        "contrato": 7041121615,
        "matricula": 98071211
      },
      {
        "igreja": "Vila Rodrigues",
        "contrato": 11026095,
        "matricula": 148746314
      },
      {
        "igreja": "Vila Velha",
        "contrato": 7016876385,
        "matricula": ""
      },
      {
        "igreja": "Vinte E Um de Setembro",
        "contrato": 12543263,
        "matricula": "SAAE-20718-3"
      },
      {
        "igreja": "Viuveira",
        "contrato": 7001734207,
        "matricula": 7001734207
      },
      {
        "igreja": "Viveiros",
        "contrato": 7036778959,
        "matricula": 97424200
      },
      {
        "igreja": "Zuca",
        "contrato": 7043430178,
        "matricula": ""
      },
 ]

menu.forEach(function(obj) {
    db.collection("igrejas").where("nome", "==", obj.igreja).get().then(function(value){
        value.docs.forEach(function(element){
            db.collection("igrejas").doc(element.id).update({
                contrato: obj.contrato,
                matricula: obj.matricula
            });
        });
    });
});