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
    "distrito": "Alagoinhas",
    "pastor": "Jeferson Carvalho",
    "regiao": "Região Leste"
  },
  {
    "distrito": "Alto do Sobradinho",
    "pastor": "Flavio Borges",
    "regiao": "Região Recôncavo Sul"
  },
  {
    "distrito": "Araci",
    "pastor": "Flávio Matos",
    "regiao": "Região Oeste"
  },
  {
    "distrito": "Btn",
    "pastor": "Ariosto Almeida",
    "regiao": "Região Norte"
  },
  {
    "distrito": "Cachoeira",
    "pastor": "Ivanildo Fernandes",
    "regiao": "Região Recôncavo"
  },
  {
    "distrito": "Capoeirucu",
    "pastor": "Tarsis Iraides",
    "regiao": "Região Recôncavo"
  },
  {
    "distrito": "Cicero Dantas",
    "pastor": "Edson Dias",
    "regiao": "Região Norte"
  },
  {
    "distrito": "Cidade Nova",
    "pastor": "Benildo Gabriel",
    "regiao": "Região Central"
  },
  {
    "distrito": "Conceicao do Coite",
    "pastor": "Misael Candido",
    "regiao": "Região Oeste"
  },
  {
    "distrito": "Conceicao do Jacuipe",
    "pastor": "Berilo Rios",
    "regiao": "Região Central"
  },
  {
    "distrito": "Coplan",
    "pastor": "José Marcelo",
    "regiao": "Região Recôncavo"
  },
  {
    "distrito": "Coqueiro",
    "pastor": "Jose Estevam",
    "regiao": "Região Oeste"
  },
  {
    "distrito": "Cruz das Almas",
    "pastor": "Marcelo Araújo",
    "regiao": "Região Recôncavo"
  },
  {
    "distrito": "Esplanada",
    "pastor": "Marlon Santos",
    "regiao": "Região Leste"
  },
  {
    "distrito": "Euclides da Cunha",
    "pastor": "Andre Luiz",
    "regiao": "Região Noroeste"
  },
  {
    "distrito": "Fadba",
    "pastor": "Luciano Paula",
    "regiao": "Região Recôncavo"
  },
  {
    "distrito": "Feira de Santana",
    "pastor": "Luiz Carlos",
    "regiao": "Região Central"
  },
  {
    "distrito": "Feira de Santana - Novo",
    "pastor": "Agady Souza",
    "regiao": "Região Centro-sul"
  },
  {
    "distrito": "Governador Mangabeira",
    "pastor": "Geovane Cândido",
    "regiao": "Região Recôncavo"
  },
  {
    "distrito": "Hildete Lomanto",
    "pastor": "Leonardo Fabiano",
    "regiao": "Região Noroeste"
  },
  {
    "distrito": "Inhambupe",
    "pastor": "Valteir Costa",
    "regiao": "Região Leste"
  },
  {
    "distrito": "Itaberaba",
    "pastor": "José Francisco",
    "regiao": "Região Centro-sul"
  },
  {
    "distrito": "Jardim Cruzeiro",
    "pastor": "Jonatas Barbosa",
    "regiao": "Região Centro-sul"
  },
  {
    "distrito": "Jiquirica",
    "pastor": " ",
    "regiao": "Região Recôncavo Sul"
  },
  {
    "distrito": "Milagres",
    "pastor": "Jose Edson",
    "regiao": "Região Centro-sul"
  },
  {
    "distrito": "Nova Fatima",
    "pastor": "Geceval Santos",
    "regiao": "Região Oeste"
  },
  {
    "distrito": "Nova Soure",
    "pastor": "Edmundo Oliveira",
    "regiao": "Região Noroeste"
  },
  {
    "distrito": "Panorama",
    "pastor": "Laercio Cardoso",
    "regiao": "Região Centro-sul"
  },
  {
    "distrito": "Parque Universitario",
    "pastor": "Florisberto Jesus",
    "regiao": "Região Central"
  },
  {
    "distrito": "Paulo Afonso",
    "pastor": "Gildasio Correia",
    "regiao": "Região Norte"
  },
  {
    "distrito": "Pre-antas",
    "pastor": "Jeferson Lisboa",
    "regiao": "Região Norte"
  },
  {
    "distrito": "Pre-santo Amaro",
    "pastor": "Jose Bonfim",
    "regiao": "Região Recôncavo"
  },
  {
    "distrito": "Quijingue",
    "pastor": "Valmir Bento",
    "regiao": "Região Noroeste"
  },
  {
    "distrito": "Ribeira do Pombal",
    "pastor": "Daniel Almeida",
    "regiao": "Região Noroeste"
  },
  {
    "distrito": "Rio Real",
    "pastor": "Mauricio Bonfim",
    "regiao": "Região Leste"
  },
  {
    "distrito": "Santa Monica",
    "pastor": "Ubirailton Moura",
    "regiao": "Região Central"
  },
  {
    "distrito": "Santo Antonio de Jesus",
    "pastor": "Joel Souza",
    "regiao": "Região Recôncavo Sul"
  },
  {
    "distrito": "Serrinha",
    "pastor": "Ulimar Santos",
    "regiao": "Região Oeste"
  },
  {
    "distrito": "Sobradinho",
    "pastor": "Melquisedeque Queiroz",
    "regiao": "Região Central"
  },
  {
    "distrito": "Tomba",
    "pastor": "Jeiglion Souza",
    "regiao": "Região Centro-sul"
  },
  {
    "distrito": "Tucano",
    "pastor": "Alberto Adrio",
    "regiao": "Região Noroeste"
  },
  {
    "distrito": "Valenca",
    "pastor": "Daniel Oliveira",
    "regiao": "Região Recôncavo Sul"
  },
  {
    "distrito": "Vinte e Um de Setembro",
    "pastor": "Reginaldo Barros",
    "regiao": "Região Leste"
  }
]

menu.forEach(function (obj) {
  db.collection("distritos").doc(obj.distrito).update({
    pastor: obj.pastor,
    regiao: obj.regiao
  });
});