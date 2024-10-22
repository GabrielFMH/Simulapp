const admin = require('firebase-admin');

// Inicializa Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.applicationDefault(),  // O usa tu clave de servicio
  databaseURL: 'https://<tu-proyecto>.firebaseio.com'
});

const db = admin.firestore();

async function insertExam() {
  const batch = db.batch();  // Crea una nueva operación en batch

  const exams = [
    {
      "examenId": "KoXMWUvT8Udqf1TWaH2b",
      "preguntas": [
        {
          "enunciado": "Pregunta 1",
          "opciones": ["Opción A", "Opción B", "Opción C", "Opción D"],
          "respuesta": "Opción A",
          "tipo": "multiple_choice"
        },
        {
          "enunciado": "Pregunta 2",
          "opciones": ["Opción 1", "Opción 2", "Opción 3", "Opción 4"],
          "respuesta": "Opción 2",
          "tipo": "multiple_choice"
        }
      ]
    }
  ];

  exams.forEach((exam) => {
    const docRef = db.collection('examenes').doc(exam.examenId);  // Usa el examenId como ID del documento
    batch.set(docRef, {
      preguntas: exam.preguntas  // Solo inserta las preguntas
    });
  });

  // Ejecuta el batch
  await batch.commit().then(() => {
    console.log('Examen insertado exitosamente!');
  }).catch((error) => {
    console.error('Error al insertar el examen: ', error);
  });
}

// Llama a la función para insertar el examen
insertExam();
