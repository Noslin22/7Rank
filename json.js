const firebase = require("firebase");
require("firebase/firestore");
firebase.initializeApp({
  apiKey: "AIzaSyA7dyDfFXnNGnQIxH2vI_y91tSeGRWILnA",
  authDomain: "igreja-4019a.firebaseapp.com",
  projectId: "igreja-4019a",
});

var db = firebase.firestore();

var menu = [
  {
      'cod': 152,
      'nome': "02 de Julho"
  },
  {
      'cod': 23,
      'nome': "15 de Novembro"
  },
  {
      'cod': 193,
      'nome': "3 Iasd Capoeirucu"
  },
  {
      'cod': 70,
      'nome': "Abare"
  },
  {
      'cod': 16,
      'nome': "Acajutiba"
  },
  {
      'cod': 97,
      'nome': "Acupe"
  },
  {
      'cod': 962,
      'nome': "Agua Branca"
  },
  {
      'cod': 116,
      'nome': "Agua Branca - Rio Real"
  },
  {
      'cod': 980,
      'nome': "Agua Fria"
  },
  {
      'cod': 823,
      'nome': "Agua Grande"
  },
  {
      'cod': 22,
      'nome': "Alagoinhas - Sede"
  },
  {
      'cod': 872,
      'nome': "Alagoinhas IV"
  },
  {
      'cod': 24,
      'nome': "Alagoinhas Velha"
  },
  {
      'cod': 41,
      'nome': "Alecrim"
  },
  {
      'cod': 256,
      'nome': "Alexandrino"
  },
  {
      'cod': 2,
      'nome': "Algodoes"
  },
  {
      'cod': 695,
      'nome': "Alto Bonito"
  },
  {
      'cod': 191,
      'nome': "Alto de Fora"
  },
  {
      'cod': 168,
      'nome': "Alto do Canuto"
  },
  {
      'cod': 367,
      'nome': "Alto do Papagaio"
  },
  {
      'cod': 570,
      'nome': "Alto do Paraiso"
  },
  {
      'cod': 936,
      'nome': "Alto do Quijingue"
  },
  {
      'cod': 89,
      'nome': "Alto do Santo Antonio"
  },
  {
      'cod': 933,
      'nome': "Alto do Sobradinho"
  },
  {
      'cod': 1017,
      'nome': "Alvorada"
  },
  {
      'cod': 90,
      'nome': "Amargosa"
  },
  {
      'cod': 10,
      'nome': "Amelia Rodrigues"
  },
  {
      'cod': 807,
      'nome': "Andarai"
  },
  {
      'cod': 513,
      'nome': "Anguera"
  },
  {
      'cod': 72,
      'nome': "Antas - Sede"
  },
  {
      'cod': 881,
      'nome': "Antonio Conselheiro"
  },
  {
      'cod': 9986,
      'nome': "Apora"
  },
  {
      'cod': 515,
      'nome': "Araca"
  },
  {
      'cod': 180,
      'nome': "Araci - Sede"
  },
  {
      'cod': 40,
      'nome': "Aramari"
  },
  {
      'cod': 296,
      'nome': "Arapua"
  },
  {
      'cod': 184,
      'nome': "Arapua - Tucano"
  },
  {
      'cod': 19,
      'nome': "Aratuipe"
  },
  {
      'cod': 511,
      'nome': "Asa Branca"
  },
  {
      'cod': 20,
      'nome': "Assembleia"
  },
  {
      'cod': 3,
      'nome': "Associacao Bahia Central"
  },
  {
      'cod': 1101,
      'nome': "Av. Airton Sena"
  },
  {
      'cod': 130,
      'nome': "Avenida E Silva Brito"
  },
  {
      'cod': 220,
      'nome': "Bairro da Estacao"
  },
  {
      'cod': 201,
      'nome': "Bairro da Santa"
  },
  {
    'cod': 8,
    'nome': "Baixa Alegre"
  },
  {
      'cod': 136,
      'nome': "Bairro Sao Bento"
  },
  {
      'cod': 257,
      'nome': "Baixa das Pedras"
  },
  {
      'cod': 4,
      'nome': "Baixa do Tanque"
  },
  {
      'cod': 297,
      'nome': "Baixa Grande"
  },
  {
      'cod': 153,
      'nome': "Baixa Grande - Cruz das Almas"
  },
  {
      'cod': 151,
      'nome': "Baixao"
  },
  {
      'cod': 312,
      'nome': "Baixao do Guai"
  },
  {
      'cod': 939,
      'nome': "Banzae"
  },
  {
      'cod': 1096,
      'nome': "Baraunas"
  },
  {
      'cod': 217,
      'nome': "Barra do Tanque"
  },
  {
      'cod': 190,
      'nome': "Barreiro"
  },
  {
      'cod': 243,
      'nome': "Barreiros"
  },
  {
      'cod': 102,
      'nome': "Barriguda"
  },
  {
      'cod': 149,
      'nome': "Barrocao II"
  },
  {
      'cod': 115,
      'nome': "Barrocas"
  },
  {
      'cod': 961,
      'nome': "Bela Vista"
  },
  {
      'cod': 128,
      'nome': "Bela Vista - Coqueiro"
  },
  {
      'cod': 143,
      'nome': "Bela Vista - Serrinha"
  },
  {
      'cod': 364,
      'nome': "Belem"
  },
  {
      'cod': 335,
      'nome': "Benone Rezende"
  },
  {
      'cod': 118,
      'nome': "Biritinga"
  },
  {
      'cod': 908,
      'nome': "Boa Esperanca"
  },
  {
      'cod': 25,
      'nome': "Boa Uniao"
  },
  {
      'cod': 365,
      'nome': "Boa Vista"
  },
  {
      'cod': 109,
      'nome': "Boa Vista de Belem"
  },
  {
      'cod': 456,
      'nome': "Boa Vista do Tupim"
  },
  {
      'cod': 901,
      'nome': "Boca da Mata"
  },
  {
      'cod': 428,
      'nome': "Bolivia"
  },
  {
      'cod': 48,
      'nome': "Bolivia II"
  },
  {
      'cod': 147,
      'nome': "Bombinha"
  },
  {
      'cod': 469,
      'nome': "Bonfim"
  },
  {
      'cod': 251,
      'nome': "Boqueirao"
  },
  {
      'cod': 138,
      'nome': "Brasilia"
  },
  {
      'cod': 512,
      'nome': "Bravo"
  },
  {
      'cod': 549,
      'nome': "Brejo do Meio"
  },
  {
      'cod': 254,
      'nome': "Brisa"
  },
  {
      'cod': 914,
      'nome': "Btn I"
  },
  {
      'cod': 1118,
      'nome': "Btn III"
  },
  {
      'cod': 27,
      'nome': "Buril"
  },
  {
      'cod': 1045,
      'nome': "Cabaceira Paraguacu"
  },
  {
      'cod': 68,
      'nome': "Cachoeira - Sede"
  },
  {
      'cod': 887,
      'nome': "Cachoeira II"
  },
  {
      'cod': 564,
      'nome': "Caimbe"
  },
  {
      'cod': 298,
      'nome': "Caldas de Cipo"
  },
  {
      'cod': 551,
      'nome': "Caldas do Jorro"
  },
  {
      'cod': 1042,
      'nome': "Caldeirao"
  },
  {
      'cod': 194,
      'nome': "Caldeirao Novo"
  },
  {
      'cod': 928,
      'nome': "Campo do Gado"
  },
  {
      'cod': 507,
      'nome': "Campo Limpo"
  },
  {
      'cod': 9732,
      'nome': "Campo Limpo II"
  },
  {
      'cod': 971,
      'nome': "Cana Brava"
  },
  {
      'cod': 510,
      'nome': "Cana Brava - Itaberaba"
  },
  {
      'cod': 93,
      'nome': "Candeal"
  },
  {
      'cod': 506,
      'nome': "Candeal - Itaberaba"
  },
  {
      'cod': 948,
      'nome': "Canudos"
  },
  {
      'cod': 366,
      'nome': "Capanema"
  },
  {
      'cod': 907,
      'nome': "Capela Alto Alegre-a"
  },
  {
      'cod': 77,
      'nome': "Capoeirucu Sede"
  },
  {
      'cod': 368,
      'nome': "Capoeirucu II"
  },
  {
      'cod': 330,
      'nome': "Cardan"
  },
  {
      'cod': 567,
      'nome': "Carnaiba"
  },
  {
      'cod': 9992,
      'nome': "Casas Populares"
  },
  {
      'cod': 124,
      'nome': "Casas Populares 2"
  },
  {
      'cod': 766,
      'nome': "Cascalheira"
  },
  {
      'cod': 162,
      'nome': "Caseb"
  },
  {
      'cod': 52,
      'nome': "Castro Alves"
  },
  {
      'cod': 888,
      'nome': "Castro Alves II"
  },
  {
      'cod': 1106,
      'nome': "Catende Azul"
  },
  {
      'cod': 1061,
      'nome': "Catu Grande"
  },
  {
      'cod': 74,
      'nome': "Caxias"
  },
  {
      'cod': 1091,
      'nome': "Celao"
  },
  {
      'cod': 931,
      'nome': "Centenario"
  },
  {
      'cod': 73,
      'nome': "Central BTN"
  },
  {
      'cod': 353,
      'nome': "Chesf"
  },
  {
      'cod': 75,
      'nome': "Cicero Dantas"
  },
  {
      'cod': 1119,
      'nome': "Cidade de Deus"
  },
  {
      'cod': 923,
      'nome': "Cidade Nova"
  },
  {
      'cod': 9987,
      'nome': "Cidade Nova - Olindina"
  },
  {
      'cod': 156,
      'nome': "Cidade Nova Sede"
  },
  {
      'cod': 927,
      'nome': "Cipoal"
  },
  {
      'cod': 1065,
      'nome': "Coite II"
  },
  {
      'cod': 658,
      'nome': "Colina das Mangueiras"
  },
  {
      'cod': 815,
      'nome': "Colonia"
  },
  {
      'cod': 28,
      'nome': "Colonia Nova"
  },
  {
      'cod': 29,
      'nome': "Colonia Velha"
  },
  {
      'cod': 82,
      'nome': "Conceicao da Feira"
  },
  {
      'cod': 211,
      'nome': "Conceicao do Almeida"
  },
  {
      'cod': 186,
      'nome': "Conceicao do Coite Sede"
  },
  {
      'cod': 522,
      'nome': "Conceicao do Jacuipe"
  },
  {
      'cod': 1095,
      'nome': "Conceicao I"
  },
  {
      'cod': 159,
      'nome': "Conceicao II"
  },
  {
      'cod': 762,
      'nome': "Conjunto Jose Ronaldo"
  },
  {
      'cod': 53,
      'nome': "Coplan"
  },
  {
      'cod': 181,
      'nome': "Coqueiro"
  },
  {
      'cod': 1135,
      'nome': "Coqueiro II"
  },
  {
      'cod': 1058,
      'nome': "Coracao de Maria"
  },
  {
      'cod': 9,
      'nome': "Coreia"
  },
  {
      'cod': 1117,
      'nome': "Coreia - Cicero Dantas"
  },
  {
      'cod': 938,
      'nome': "Coronel Vicente"
  },
  {
      'cod': 1025,
      'nome': "Crenguenhem"
  },
  {
      'cod': 30,
      'nome': "Crisopolis"
  },
  {
      'cod': 51,
      'nome': "Cruz das Almas"
  },
  {
      'cod': 1157,
      'nome': "Cruzeiro"
  },
  {
      'cod': 299,
      'nome': "Curral Falso"
  },
  {
      'cod': 9984,
      'nome': "Curral Velho"
  },
  {
      'cod': 31,
      'nome': "Dona Maria"
  },
  {
      'cod': 12,
      'nome': "Dona Rosa"
  },
  {
      'cod': 50,
      'nome': "Duque de Caxias"
  },
  {
      'cod': 135,
      'nome': "Elisio Medrado"
  },
  {
      'cod': 9993,
      'nome': "Embira"
  },
  {
      'cod': 655,
      'nome': "Encruzilhada Valente"
  },
  {
      'cod': 213,
      'nome': "Encruzo"
  },
  {
      'cod': 95,
      'nome': "Encruzo II"
  },
  {
      'cod': 852,
      'nome': "Entrada da Pedra"
  },
  {
      'cod': 120,
      'nome': "Entre Rios"
  },
  {
      'cod': 250,
      'nome': "Entroncamento"
  },
  {
      'cod': 9915,
      'nome': "Entroncamento de Antas"
  },
  {
      'cod': 429,
      'nome': "Entroncamento de Laje"
  },
  {
      'cod': 26,
      'nome': "Entroncamento de Valenca"
  },
  {
      'cod': 932,
      'nome': "Entroncamento Satiro Dias"
  },
  {
      'cod': 17,
      'nome': "Esplanada"
  },
  {
      'cod': 1019,
      'nome': "Estacao"
  },
  {
      'cod': 222,
      'nome': "Estevao"
  },
  {
      'cod': 555,
      'nome': "Euclides da Cunha"
  },
  {
      'cod': 76,
      'nome': "Fatima"
  },
  {
      'cod': 176,
      'nome': "Fazenda Cajarana"
  },
  {
      'cod': 1076,
      'nome': "Fazenda Diamante"
  },
  {
      'cod': 175,
      'nome': "Fazenda do Brejo"
  },
  {
      'cod': 192,
      'nome': "Fazenda Guerra"
  },
  {
      'cod': 995,
      'nome': "Fazenda Juazeiro"
  },
  {
      'cod': 789,
      'nome': "Fazenda Mancambira"
  },
  {
      'cod': 229,
      'nome': "Fazenda Mercantil"
  },
  {
      'cod': 430,
      'nome': "Fazenda Piau"
  },
  {
      'cod': 300,
      'nome': "Fazenda Sao Jose"
  },
  {
      'cod': 183,
      'nome': "Fazenda Verdes Campos"
  },
  {
      'cod': 301,
      'nome': "Feira da Serra"
  },
  {
      'cod': 516,
      'nome': "Feira de Santana - Central"
  },
  {
      'cod': 157,
      'nome': "Feira VI"
  },
  {
      'cod': 334,
      'nome': "Feira VII"
  },
  {
      'cod': 521,
      'nome': "Feira X"
  },
  {
      'cod': 1083,
      'nome': "Felicidade"
  },
  {
      'cod': 9979,
      'nome': "Formiga II"
  },
  {
      'cod': 527,
      'nome': "Fraternidade"
  },
  {
      'cod': 425,
      'nome': "Frei Apolonio"
  },
  {
      'cod': 119,
      'nome': "Funcionarios Publicos"
  },
  {
      'cod': 925,
      'nome': "Furtado"
  },
  {
      'cod': 278,
      'nome': "Gabriela"
  },
  {
      'cod': 204,
      'nome': "Gameleira"
  },
  {
      'cod': 242,
      'nome': "Gaviao I"
  },
  {
      'cod': 244,
      'nome': "Gaviao II"
  },
  {
      'cod': 203,
      'nome': "Gaviao III"
  },
  {
      'cod': 302,
      'nome': "Genipapo"
  },
  {
      'cod': 54,
      'nome': "Geolandia"
  },
  {
      'cod': 158,
      'nome': "George Americo"
  },
  {
      'cod': 49,
      'nome': "Gereba"
  },
  {
      'cod': 112,
      'nome': "Getulio Vargas"
  },
  {
      'cod': 1137,
      'nome': "Gitirana"
  },
  {
      'cod': 1052,
      'nome': "Gloria"
  },
  {
      'cod': 131,
      'nome': "Goiabeira"
  },
  {
      'cod': 56,
      'nome': "Governador Mangabeira"
  },
  {
      'cod': 9727,
      'nome': "Gravata"
  },
  {
      'cod': 470,
      'nome': "Grupo da Prainha"
  },
  {
      'cod': 214,
      'nome': "Guaibim"
  },
  {
      'cod': 117,
      'nome': "Guanabara"
  },
  {
    'cod': 228,
    'nome': "Guaracu"
  },
  {
      'cod': 1150,
      'nome': "Guarani"
  },
  {
      'cod': 303,
      'nome': "Heliopolis"
  },
  {
      'cod': 879,
      'nome': "Heliopolis II"
  },
  {
      'cod': 126,
      'nome': "Hildete Lomanto"
  },
  {
      'cod': 13,
      'nome': "Humildes"
  },
  {
      'cod': 451,
      'nome': "Iacu"
  },
  {
      'cod': 246,
      'nome': "Ibatui"
  },
  {
      'cod': 863,
      'nome': "Ibo"
  },
  {
      'cod': 674,
      'nome': "Fadba"
  },
  {
      'cod': 237,
      'nome': "Igreja do Rose"
  },
  {
      'cod': 467,
      'nome': "Imbiara"
  },
  {
      'cod': 33,
      'nome': "Inhambupe"
  },
  {
      'cod': 6,
      'nome': "Inocoop"
  },
  {
      'cod': 509,
      'nome': "Ipira"
  },
  {
      'cod': 520,
      'nome': "Ipuacu"
  },
  {
      'cod': 530,
      'nome': "Irara"
  },
  {
      'cod': 230,
      'nome': "Irma Dulce"
  },
  {
      'cod': 445,
      'nome': "Itaberaba"
  },
  {
      'cod': 454,
      'nome': "Itaete"
  },
  {
      'cod': 34,
      'nome': "Itamira"
  },
  {
      'cod': 137,
      'nome': "Itapicuru"
  },
  {
      'cod': 795,
      'nome': "Itatim"
  },
  {
      'cod': 210,
      'nome': "Jacare"
  },
  {
      'cod': 917,
      'nome': "Jacu"
  },
  {
      'cod': 877,
      'nome': "Jambeiro"
  },
  {
      'cod': 1056,
      'nome': "Jardim Acacia - Tomba"
  },
  {
      'cod': 232,
      'nome': "Jardim America"
  },
  {
      'cod': 78,
      'nome': "Jardim Bahia"
  },
  {
      'cod': 508,
      'nome': "Jardim Cruzeiro"
  },
  {
      'cod': 998,
      'nome': "Jardim Cruzeiro 2"
  },
  {
      'cod': 9754,
      'nome': "Jardim das Palmeiras"
  },
  {
      'cod': 847,
      'nome': "Jardim Maravilha"
  },
  {
      'cod': 1159,
      'nome': "Jenipapo"
  },
  {
      'cod': 169,
      'nome': "Jenipapo - Pq. Universitario"
  },
  {
      'cod': 954,
      'nome': "Jequie Mirim"
  },
  {
      'cod': 79,
      'nome': "Jeremoabo"
  },
  {
      'cod': 1,
      'nome': "Jiquirica"
  },
  {
      'cod': 453,
      'nome': "Joao Amaro"
  },
  {
      'cod': 141,
      'nome': "Joao Paulo II"
  },
  {
      'cod': 916,
      'nome': "Joao Vieira"
  },
  {
      'cod': 144,
      'nome': "Jorrinho"
  },
  {
      'cod': 127,
      'nome': "Kauanga"
  },
  {
      'cod': 44,
      'nome': "Km 135"
  },
  {
      'cod': 1114,
      'nome': "Km 18"
  },
  {
      'cod': 92,
      'nome': "Km 25"
  },
  {
      'cod': 207,
      'nome': "Km 37"
  },
  {
      'cod': 782,
      'nome': "Km 6"
  },
  {
      'cod': 42,
      'nome': "Km 82"
  },
  {
      'cod': 1068,
      'nome': "Lages"
  },
  {
      'cod': 1138,
      'nome': "Lagoa da Jurema"
  },
  {
      'cod': 897,
      'nome': "Lagoa da Picada"
  },
  {
      'cod': 57,
      'nome': "Lagoa da Pumba"
  },
  {
      'cod': 806,
      'nome': "Lagoa do Boi"
  },
  {
      'cod': 123,
      'nome': "Lagoa do Cupan"
  },
  {
      'cod': 668,
      'nome': "Lagoa do Mato"
  },
  {
      'cod': 129,
      'nome': "Lagoa do Ramo"
  },
  {
      'cod': 9978,
      'nome': "Lagoa Fechada"
  },
  {
      'cod': 422,
      'nome': "Lagoa Grande"
  },
  {
      'cod': 918,
      'nome': "Lagoa I"
  },
  {
      'cod': 163,
      'nome': "Lagoa Salgada"
  },
  {
      'cod': 171,
      'nome': "Lagoeta"
  },
  {
      'cod': 1072,
      'nome': "Lagoinha das Pedras"
  },
  {
      'cod': 1041,
      'nome': "Laje"
  },
  {
      'cod': 231,
      'nome': "Limeira"
  },
  {
      'cod': 154,
      'nome': "Lisboa"
  },
  {
      'cod': 45,
      'nome': "Lot. Raimundo Guimaraes"
  },
  {
      'cod': 783,
      'nome': "Loteamento Primavera"
  },
  {
      'cod': 58,
      'nome': "Macaubas"
  },
  {
      'cod': 1107,
      'nome': "Magalhaes"
  },
  {
      'cod': 125,
      'nome': "Malombe"
  },
  {
      'cod': 200,
      'nome': "Malvinas"
  },
  {
      'cod': 165,
      'nome': "Mangabeira"
  },
  {
      'cod': 178,
      'nome': "Mangabeira - Irara"
  },
  {
      'cod': 848,
      'nome': "Mangalo"
  },
  {
      'cod': 1006,
      'nome': "Mangalo II"
  },
  {
      'cod': 55,
      'nome': "Manoel Vitorino"
  },
  {
      'cod': 370,
      'nome': "Maragojipe"
  },
  {
      'cod': 1122,
      'nome': "Maranco"
  },
  {
      'cod': 448,
      'nome': "Marcionilio Souza"
  },
  {
      'cod': 1082,
      'nome': "Maria Quiteria"
  },
  {
      'cod': 1067,
      'nome': "Marieta Ferraz"
  },
  {
      'cod': 9985,
      'nome': "Mata da Ladeira"
  },
  {
      'cod': 1162,
      'nome': "Matinha"
  },
  {
      'cod': 155,
      'nome': "Meio de Campo"
  },
  {
      'cod': 371,
      'nome': "Merces"
  },
  {
      'cod': 1140,
      'nome': "Milagres"
  },
  {
      'cod': 47,
      'nome': "Miradouro"
  },
  {
      'cod': 546,
      'nome': "Monte alamo"
  },
  {
      'cod': 361,
      'nome': "Monte Belo"
  },
  {
      'cod': 83,
      'nome': "Monte Castelo"
  },
  {
      'cod': 197,
      'nome': "Morada Velha"
  },
  {
      'cod': 209,
      'nome': "Morais"
  },
  {
      'cod': 145,
      'nome': "Moria"
  },
  {
      'cod': 270,
      'nome': "Morro de Sao Paulo"
  },
  {
      'cod': 861,
      'nome': "Moxoto"
  },
  {
      'cod': 1018,
      'nome': "Mucambinho de Limeira"
  },
  {
      'cod': 694,
      'nome': "Mulungu"
  },
  {
      'cod': 306,
      'nome': "Mulungu - Ribeira do Pombal"
  },
  {
      'cod': 9725,
      'nome': "Municipio"
  },
  {
      'cod': 839,
      'nome': "Murilo Leite"
  },
  {
      'cod': 975,
      'nome': "Muringue"
  },
  {
      'cod': 268,
      'nome': "Muriti"
  },
  {
      'cod': 218,
      'nome': "Muritiba"
  },
  {
      'cod': 1090,
      'nome': "Muritiba II"
  },
  {
      'cod': 983,
      'nome': "Muritibinha"
  },
  {
      'cod': 84,
      'nome': "Murutuba"
  },
  {
      'cod': 9990,
      'nome': "Mutirao"
  },
  {
      'cod': 150,
      'nome': "Mutuipe"
  },
  {
      'cod': 374,
      'nome': "Nage"
  },
  {
      'cod': 608,
      'nome': "Nazare das Farinhas"
  },
  {
      'cod': 978,
      'nome': "Nazare das Farinhas II"
  },
  {
      'cod': 255,
      'nome': "Noide Cerqueira"
  },
  {
      'cod': 103,
      'nome': "Nova America"
  },
  {
      'cod': 817,
      'nome': "Nova Brasilia"
  },
  {
      'cod': 104,
      'nome': "Nova Brasilia - 21 de Setembro"
  },
  {
      'cod': 212,
      'nome': "Nova Canaa"
  },
  {
      'cod': 307,
      'nome': "Nova Esperanca"
  },
  {
      'cod': 113,
      'nome': "Nova Esperanca - Cachoeira"
  },
  {
      'cod': 1040,
      'nome': "Nova Esperanca - Alto do Sobradinho"
  },
  {
      'cod': 238,
      'nome': "Nova Fatima"
  },
  {
      'cod': 134,
      'nome': "Nova Jerusalem"
  },
  {
      'cod': 1092,
      'nome': "Nova Minacao"
  },
  {
      'cod': 929,
      'nome': "Nova Pastora"
  },
  {
      'cod': 308,
      'nome': "Nova Soure"
  },
  {
      'cod': 205,
      'nome': "Novo Horizonte - Valenca"
  },
  {
      'cod': 164,
      'nome': "Novo Horizonte"
  },
  {
      'cod': 996,
      'nome': "Novo Horizonte - Alagoinhas"
  },
  {
      'cod': 981,
      'nome': "Novo Inhambupe"
  },
  {
      'cod': 935,
      'nome': "Novo Triunfo"
  },
  {
      'cod': 35,
      'nome': "Olindina"
  },
  {
      'cod': 21,
      'nome': "Orobo"
  },
  {
      'cod': 9991,
      'nome': "Ouro Verde"
  },
  {
      'cod': 524,
      'nome': "Panorama"
  },
  {
      'cod': 525,
      'nome': "Paraguacu"
  },
  {
      'cod': 518,
      'nome': "Parque Getulio Vargas"
  },
  {
      'cod': 160,
      'nome': "Parque Ipe"
  },
  {
      'cod': 363,
      'nome': "Parque Sabia"
  },
  {
      'cod': 982,
      'nome': "Parque Sao Bernardo"
  },
  {
      'cod': 1057,
      'nome': "Parque Servilha"
  },
  {
      'cod': 133,
      'nome': "Pau Ferro"
  },
  {
      'cod': 69,
      'nome': "Paulo Afonso"
  },
  {
      'cod': 987,
      'nome': "Pe de Serra - Inhambupe"
  },
  {
      'cod': 9999,
      'nome': "Pe de Serra"
  },
  {
      'cod': 960,
      'nome': "Pe de Serra - Nova Fatima"
  },
  {
      'cod': 121,
      'nome': "Pedra"
  },
  {
      'cod': 1094,
      'nome': "Pedra Ferrada"
  },
  {
      'cod': 101,
      'nome': "Pedra Ferrada II"
  },
  {
      'cod': 685,
      'nome': "Pedra Vermelha"
  },
  {
      'cod': 1171,
      'nome': "Pedras - Tucano"
  },
  {
      'cod': 802,
      'nome': "Pedras Altas"
  },
  {
      'cod': 705,
      'nome': "Pedro Alexandre"
  },
  {
      'cod': 64,
      'nome': "Pedro Tibucio"
  },
  {
      'cod': 1053,
      'nome': "Petim"
  },
  {
      'cod': 36,
      'nome': "Petrolar"
  },
  {
      'cod': 781,
      'nome': "Pindoba"
  },
  {
      'cod': 657,
      'nome': "Pinheiro"
  },
  {
      'cod': 9728,
      'nome': "Poco Augustinho"
  },
  {
      'cod': 372,
      'nome': "Poco Gameleira"
  },
  {
      'cod': 309,
      'nome': "Pombalzinho"
  },
  {
      'cod': 223,
      'nome': "Ponto Central"
  },
  {
    'cod': 132,
    'nome': "Populares"
  },
  {
      'cod': 14,
      'nome': "Portao"
  },
  {
      'cod': 375,
      'nome': "Porto Maragojipe"
  },
  {
      'cod': 219,
      'nome': "Posto Aguia"
  },
  {
      'cod': 909,
      'nome': "Posto Aguia II"
  },
  {
      'cod': 80,
      'nome': "Povoado Araujo"
  },
  {
      'cod': 9988,
      'nome': "Povoado Aroeira"
  },
  {
      'cod': 834,
      'nome': "Povoado de Barreiras"
  },
  {
      'cod': 304,
      'nome': "Povoado Jua"
  },
  {
      'cod': 71,
      'nome': "Povoado Serra Branca"
  },
  {
      'cod': 7,
      'nome': "Pumba I"
  },
  {
      'cod': 182,
      'nome': "Queimada do Borges"
  },
  {
      'cod': 59,
      'nome': "Queimadas"
  },
  {
      'cod': 532,
      'nome': "Queimadinha"
  },
  {
      'cod': 544,
      'nome': "Quijingue"
  },
  {
      'cod': 9995,
      'nome': "Quijingue II"
  },
  {
      'cod': 173,
      'nome': "Quixaba"
  },
  {
      'cod': 9996,
      'nome': "Quizanga"
  },
  {
      'cod': 310,
      'nome': "Raspador"
  },
  {
      'cod': 1156,
      'nome': "Recanto Paraguacu"
  },
  {
      'cod': 67,
      'nome': "Remedios"
  },
  {
      'cod': 697,
      'nome': "Renascer"
  },
  {
      'cod': 1129,
      'nome': "Retiro"
  },
  {
      'cod': 172,
      'nome': "Retirolandia"
  },
  {
      'cod': 234,
      'nome': "Riachao do Jacuipe"
  },
  {
      'cod': 329,
      'nome': "Riacho do Boi"
  },
  {
      'cod': 185,
      'nome': "Ribeira"
  },
  {
      'cod': 311,
      'nome': "Ribeira do Amparo"
  },
  {
      'cod': 295,
      'nome': "Ribeira do Pombal"
  },
  {
      'cod': 15,
      'nome': "Ribeira II"
  },
  {
      'cod': 37,
      'nome': "Rio das Pedras"
  },
  {
      'cod': 751,
      'nome': "Rio do Peixe"
  },
  {
      'cod': 195,
      'nome': "Rio do Peixe - Tucano"
  },
  {
      'cod': 18,
      'nome': "Rio Real"
  },
  {
      'cod': 105,
      'nome': "Rodelas"
  },
  {
      'cod': 241,
      'nome': "Rodoviario"
  },
  {
      'cod': 32,
      'nome': "Rua Camacari"
  },
  {
      'cod': 96,
      'nome': "Rua da Palha"
  },
  {
      'cod': 1066,
      'nome': "Rua do Catu"
  },
  {
      'cod': 519,
      'nome': "Rua Nova"
  },
  {
      'cod': 452,
      'nome': "Rui Barbosa"
  },
  {
      'cod': 46,
      'nome': "Rui Barbosa-a"
  },
  {
      'cod': 99,
      'nome': "Sacramento-a"
  },
  {
      'cod': 174,
      'nome': "Salgadalia"
  },
  {
      'cod': 111,
      'nome': "Salgadeira"
  },
  {
      'cod': 700,
      'nome': "Salgado"
  },
  {
      'cod': 613,
      'nome': "Samambaia"
  },
  {
      'cod': 167,
      'nome': "Santa Barbara"
  },
  {
      'cod': 704,
      'nome': "Santa Brigida"
  },
  {
      'cod': 189,
      'nome': "Santa Luz"
  },
  {
      'cod': 161,
      'nome': "Santa Monica - Sede"
  },
  {
      'cod': 683,
      'nome': "Santa Rita de Cassia"
  },
  {
      'cod': 885,
      'nome': "Santa Terezinha - Coplan"
  },
  {
      'cod': 38,
      'nome': "Santa Terezinha"
  },
  {
      'cod': 100,
      'nome': "Santo Amaro da Purificacao"
  },
  {
      'cod': 240,
      'nome': "Santo Antonio"
  },
  {
      'cod': 432,
      'nome': "Santo Antonio de Jesus"
  },
  {
      'cod': 332,
      'nome': "Santo Antonio dos Prazeres"
  },
  {
      'cod': 529,
      'nome': "Santo Estevao"
  },
  {
      'cod': 1081,
      'nome': "Santuario 200"
  },
  {
      'cod': 859,
      'nome': "Sao Benedito"
  },
  {
      'cod': 313,
      'nome': "Sao Bento"
  },
  {
      'cod': 166,
      'nome': "Sao Cristovao - Feira"
  },
  {
      'cod': 245,
      'nome': "Sao Domingos"
  },
  {
      'cod': 221,
      'nome': "Sao Felipe"
  },
  {
      'cod': 376,
      'nome': "Sao Felix"
  },
  {
      'cod': 85,
      'nome': "Sao Goncalo dos Campos"
  },
  {
      'cod': 483,
      'nome': "Sao Joao"
  },
  {
      'cod': 249,
      'nome': "Sao Jose"
  },
  {
      'cod': 60,
      'nome': "Sao Jose do Itapora"
  },
  {
      'cod': 433,
      'nome': "Sao Miguel das Matas"
  },
  {
      'cod': 61,
      'nome': "Sapeacu"
  },
  {
      'cod': 725,
      'nome': "Sapucaia"
  },
  {
      'cod': 122,
      'nome': "Satiro Dias"
  },
  {
      'cod': 98,
      'nome': "Saubara"
  },
  {
      'cod': 314,
      'nome': "Segredo"
  },
  {
      'cod': 423,
      'nome': "Serra"
  },
  {
      'cod': 698,
      'nome': "Serra Grande"
  },
  {
      'cod': 87,
      'nome': "Serra Grande - Jiquirica"
  },
  {
      'cod': 1062,
      'nome': "Serrana"
  },
  {
      'cod': 5,
      'nome': "Serraria II"
  },
  {
      'cod': 187,
      'nome': "Serrinha"
  },
  {
      'cod': 1126,
      'nome': "Serrote do Meio"
  },
  {
      'cod': 199,
      'nome': "Sim"
  },
  {
      'cod': 252,
      'nome': "Sinunga de Loza"
  },
  {
      'cod': 146,
      'nome': "Sitio do Meio"
  },
  {
      'cod': 148,
      'nome': "Sitio do Quijingue"
  },
  {
      'cod': 81,
      'nome': "Sitio do Quinto"
  },
  {
      'cod': 1100,
      'nome': "Sitio Novo"
  },
  {
      'cod': 224,
      'nome': "Sitio Pascoal"
  },
  {
      'cod': 505,
      'nome': "Sobradinho"
  },
  {
      'cod': 62,
      'nome': "Sobrado"
  },
  {
      'cod': 170,
      'nome': "Soter Cardoso"
  },
  {
      'cod': 63,
      'nome': "Suzana"
  },
  {
      'cod': 1172,
      'nome': "Tamandari"
  },
  {
      'cod': 826,
      'nome': "Tanque do Marques"
  },
  {
      'cod': 1020,
      'nome': "Tanque do Rumo"
  },
  {
      'cod': 1014,
      'nome': "Tanquinho - Inhambupe"
  },
  {
      'cod': 43,
      'nome': "Tanquinho"
  },
  {
      'cod': 770,
      'nome': "Tapera-a"
  },
  {
      'cod': 94,
      'nome': "Taperoa"
  },
  {
      'cod': 1166,
      'nome': "Tapuio"
  },
  {
      'cod': 832,
      'nome': "Teodoro Sampaio"
  },
  {
      'cod': 949,
      'nome': "Teofilandia"
  },
  {
      'cod': 142,
      'nome': "Teresopolis"
  },
  {
      'cod': 568,
      'nome': "Terra Branca"
  },
  {
      'cod': 65,
      'nome': "Terra Nova"
  },
  {
      'cod': 91,
      'nome': "Terra Preta"
  },
  {
      'cod': 140,
      'nome': "Terra Santa"
  },
  {
      'cod': 1155,
      'nome': "Tibiri"
  },
  {
      'cod': 269,
      'nome': "Timbo"
  },
  {
      'cod': 523,
      'nome': "Tomba"
  },
  {
      'cod': 86,
      'nome': "Tororo"
  },
  {
      'cod': 226,
      'nome': "Touquinha"
  },
  {
      'cod': 942,
      'nome': "Treze de Maio"
  },
  {
      'cod': 707,
      'nome': "Trindade-a"
  },
  {
      'cod': 215,
      'nome': "Tucano"
  },
  {
      'cod': 1064,
      'nome': "Tupy Caldas"
  },
  {
      'cod': 561,
      'nome': "Uaua"
  },
  {
      'cod': 1152,
      'nome': "Una Mirim"
  },
  {
      'cod': 715,
      'nome': "Urbis"
  },
  {
      'cod': 435,
      'nome': "Urbis III"
  },
  {
      'cod': 431,
      'nome': "Urbis IV"
  },
  {
      'cod': 436,
      'nome': "Urbis Valenca"
  },
  {
      'cod': 107,
      'nome': "Urbis - Itamira"
  },
  {
      'cod': 88,
      'nome': "Valenca"
  },
  {
      'cod': 1087,
      'nome': "Valente"
  },
  {
      'cod': 188,
      'nome': "Vargem Grande"
  },
  {
      'cod': 9917,
      'nome': "Varginha"
  },
  {
      'cod': 1154,
      'nome': "Vila Aparecida"
  },
  {
      'cod': 569,
      'nome': "Vila Canaa"
  },
  {
      'cod': 239,
      'nome': "Vila de Fatima"
  },
  {
      'cod': 236,
      'nome': "Vila Esperanca"
  },
  {
      'cod': 114,
      'nome': "Vila Nova - Rio Real"
  },
  {
      'cod': 248,
      'nome': "Vila Operaria"
  },
  {
      'cod': 1109,
      'nome': "Vila Rica - Feira"
  },
  {
      'cod': 315,
      'nome': "Vila Rodrigues"
  },
  {
      'cod': 1145,
      'nome': "Vila Velha"
  },
  {
      'cod': 106,
      'nome': "Vilanova"
  },
  {
      'cod': 39,
      'nome': "Vinte e Um de Setembro"
  },
  {
      'cod': 672,
      'nome': "Viuveira"
  },
  {
      'cod': 11,
      'nome': "Viveiros"
  },
  {
      'cod': 208,
      'nome': "Zuca"
  }
]

  db.collection("igrejas").orderBy('cod').get().then((value) => {
    value.docs.forEach((doc) => {
      console.log(doc.data()['cod']);
    });
  });
