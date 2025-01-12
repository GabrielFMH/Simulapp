import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // Asegúrate de importar tu archivo de configuración de Firebase

// Función para inicializar Firebase
Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

// Datos de las preguntas que deseas insertar
const List<Map<String, dynamic>> nuevasPreguntas = [
    {
        "enunciado": "Why does the author provide the information that 'Available data indicate that discarded biomass (organic matter from living things) amounts to 25–30 percent of official catch, or about 30 million metric tons'?",
        "opciones": ["A. To disprove the claim that it is difficult to accurately estimate the extent of the bycatch problem", "B. To illustrate the extreme effectiveness of the longline and trawling methods", "C. To suggest that uncertainty about the true extent of bycatch does not leave in doubt that it is a problem", "D. To indicate that data about bycatch are available only from fisheries having the right kind of gear"],
        "respuesta": "C",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "According to paragraph 1, which of the following is true about the impact of various methods of fishing on the problem of bycatch?",
        "opciones": ["A. Almost all commercial fishing methods capture fish and animals that the fishers do not want.", "B. Switching from trawling to longline fishing would save seabirds and turtles from being unintentionally caught.", "C. Longline fishing is particularly dangerous for dolphins and whales.", "D. Trawling on the ocean floor produces less bycatch than does trawling through mid-ocean waters."],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "The word 'acute' in the passage is closest in meaning to",
        "opciones": ["A. common", "B. severe", "C. complicated", "D. noticeable"],
        "respuesta": "B",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "According to paragraph 2, why have larger mesh sizes not provided a practical solution to bycatch in shrimp fishing?",
        "opciones": ["A. Larger openings increase the risk that nets will get tangled or damaged as they are being hauled over the sides of the vessel.", "B. Openings large enough to prevent the capture of juvenile and other undesirable fish would also release the shrimp.", "C. Large mesh sizes are more likely to result in fish getting stuck partway through, causing more deaths within the catch.", "D. When nets grow full, they still trap fish that cannot reach the mesh openings."],
        "respuesta": "D",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "According to paragraph 3, which of the following is NOT a problem associated with bycatch in shrimp fishing?",
        "opciones": ["A. Shrimp fishers have to buy more fuel because of the added weight of the extra fish in their nets.", "B. The population of recreational and commercial species declines because much of the bycatch is their prey, resulting in a food shortage for them.", "C. Shrimp fishers must spend time sorting the shrimp from the bycatch, and some shrimp spoil during this time.", "D. The populations of some species of fish are reduced because so many of their young are caught in shrimp nets."],
        "respuesta": "B",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "According to paragraph 4, how does bycatch sometimes benefit sport fish, seabird, crab, and even shrimp populations?",
        "opciones": ["A. The discarded fish provide these species with a significant amount of food that would otherwise be unavailable to them.", "B. Fishing eliminates up to 40 to 60 percent of the predators of these species, most of which are caught unintentionally.", "C. These fish and other animals may be caught unintentionally in overcrowded locations and then released into more favorable environments.", "D. Many of the competitors of these species are eliminated by fishing, leaving them with access to more food and other resources."],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "Which of the sentences below best expresses the essential information in the highlighted sentence in paragraph 5? Incorrect choices change the meaning in important ways or leave out essential information.",
        "opciones": ["A. Overfishing and overdiscarding of jellyfish, ocean-bottom invertebrates, plankton, and planktivores are transforming the ocean in a process known as fishing down of food webs.", "B. Overdiscarding bycatch simplifies the food web by favoring the kinds of predators that feed on such prey as jellyfish, ocean-bottom invertebrates, and planktivores.", "C. Fishing down of food webs may occur if overfishing and bycatch disposal result in the disappearance of species at the top of the food web and the dominance of species near the bottom.", "D. Overfishing and overdiscarding is a syndrome that affects not only top predators and large species but also microbes, jellyfish, ocean-bottom invertebrates, plankton, and planktivores."],
        "respuesta": "C",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "What does paragraph 5 suggest is the reason why landing rates of the most valuable species fell 25 percent in the last three decades of the twentieth century?",
        "opciones": ["A. Changes in technology led many fishers to shift from a focus on near-bottom species to lower-value open-ocean species.", "B. Around the world, the number of people and ships involved in the fishing trade declined because of changes in the demand for fish.", "C. The total amount of fish in the ocean decreased significantly, leading to a steady decrease in global total catch.", "D. The most valuable species make up a much smaller percentage of the total sea population than they used to."],
        "respuesta": "D",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "In the paragraph below, there is a missing sentence. Look at the paragraph and indicate (A, B, C and D) where the following sentence could be added to the passage. **Turtles were not the only marine species to benefit from new catch techniques.**",
        "opciones": ["A. Option A", "B. Option B", "C. Option C", "D. Option D"],
        "respuesta": "C",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "According to paragraph 1, all of the following are controls that held together the Roman world EXCEPT",
        "opciones": ["A. administrative and legal systems", "B. the presence of the military", "C. a common language", "D. transportation networks"],
        "respuesta": "C",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "According to paragraph 2, which of the following was NOT characteristic of Rome’s early development?",
        "opciones": ["A. Expansion by sea invasion", "B. Territorial expansion", "C. Expansion from one original settlement", "D. Expansion through invading armies"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "Why does the author mention 'Alexander the Great' in the passage?",
        "opciones": ["A. To acknowledge that Greek civilization also expanded by land conquest", "B. To compare Greek leaders to Roman leaders", "C. To give an example of a Greek leader whom Romans studied", "D. To indicate the superior organization of the Greek military"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "The word 'fostered' in the passage is closest in meaning to",
        "opciones": ["A. accepted", "B. combined", "C. introduced", "D. encouraged"],
        "respuesta": "D",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "Paragraph 3 suggests which of the following about the people of Latium?",
        "opciones": ["A. Their economy was based on trade relations with other settlements.", "B. They held different values than the people of Rome.", "C. Agriculture played a significant role in their society.", "D. They possessed unusual knowledge of animal instincts."],
        "respuesta": "C",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "Paragraph 4 indicates that some historians admire Roman civilization because of",
        "opciones": ["A. the diversity of cultures within Roman society", "B. its strength", "C. its innovative nature", "D. the large body of literature that it developed"],
        "respuesta": "B",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "According to paragraph 4, intellectual Romans such as Horace held which of the following opinions about their civilization?",
        "opciones": ["A. Ancient works of Greece held little value in the Roman world.", "B. The Greek civilization had been surpassed by the Romans.", "C. Roman civilization produced little that was original or memorable.", "D. Romans valued certain types of innovations that had been ignored by ancient Greeks."],
        "respuesta": "C",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "Which of the following statements about leading Roman soldiers and statesmen is supported by paragraphs 5 and 6?",
        "opciones": ["A. They could read and write the Greek language.", "B. They frequently wrote poetry and plays.", "C. They focused their writing on military matters.", "D. They wrote according to the philosophical laws of the Greeks."],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "TOEFL"
    },
    {
        "enunciado": "In the paragraph below, there is a missing sentence. Look at the paragraph and indicate (A, B, C and D) where the following sentence could be added to the passage. **They esteem symbols of Roman power, such as the massive Colosseum.**",
        "opciones": ["A. Option A", "B. Option B", "C. Option C", "D. Option D"],
        "respuesta": "B",
        "tipo": "Reading",
        "examen": "TOEFL"
    },

  {
    "enunciado": "The ancient city of Caral, located approximately 200 kilometers north of Lima, Peru, is considered one of the oldest urban centers in the Americas. Founded around 2600 B.C., Caral flourished for over a millennium. At its zenith, the city likely housed thousands of residents for more than 60 hectares. The city was well-planned, featuring complex residential units, monumental architecture, including six large pyramidal structures, and an intricate system of irrigation for agriculture.\n\nCaral was a significant hub in the trade networks that linked the Peruvian coast to the Andean highlands. The presence of marine shell beads and remnants of distant plants and animals indicates broad trading connections. Moreover, archaeological evidence suggests that Caral might have had a profound religious and cultural influence on surrounding regions. The discovery of musical instruments and the layout of the city, which aligns with astronomical events, underscores its cultural complexity and significance.\n\nDespite the absence of warfare artifacts, which is unusual for pre-Columbian sites in the Americas, Caral appears to have maintained its prominence and growth through trade and a focus on cultural development. The eventual decline of Caral, around 1800 B.C., remains a topic of research, with theories pointing to environmental changes and shifts in trade routes as possible causes.\n\nWhat was a major factor in the growth of Caral?",
    "examen": "TOEFL",
    "opciones": ["A. Extensive warfare with neighboring regions.", "B. Trade networks linking the coast and highlands.", "C. Isolation from other cultural centers.", "D. Lack of religious and cultural development."],
    "respuesta": "B",
    "tipo": "Reading"
  },
  {
    "enunciado": "The ancient city of Caral, located approximately 200 kilometers north of Lima, Peru, is considered one of the oldest urban centers in the Americas. Founded around 2600 B.C., Caral flourished for over a millennium. At its zenith, the city likely housed thousands of residents for more than 60 hectares. The city was well-planned, featuring complex residential units, monumental architecture, including six large pyramidal structures, and an intricate system of irrigation for agriculture.\n\nCaral was a significant hub in the trade networks that linked the Peruvian coast to the Andean highlands. The presence of marine shell beads and remnants of distant plants and animals indicates broad trading connections. Moreover, archaeological evidence suggests that Caral might have had a profound religious and cultural influence on surrounding regions. The discovery of musical instruments and the layout of the city, which aligns with astronomical events, underscores its cultural complexity and significance.\n\nDespite the absence of warfare artifacts, which is unusual for pre-Columbian sites in the Americas, Caral appears to have maintained its prominence and growth through trade and a focus on cultural development. The eventual decline of Caral, around 1800 B.C., remains a topic of research, with theories pointing to environmental changes and shifts in trade routes as possible causes.\n\nWhich statement is true about Caral based on the passage?",
    "examen": "TOEFL",
    "opciones": ["A. The city was characterized by frequent warfare.", "B. Caral was primarily an agricultural community with little trade.", "C. The city layout suggests an alignment with astronomical events.", "D. Caral lacked any form of monumental architecture."],
    "respuesta": "C",
    "tipo": "Reading"
  },
  {
    "enunciado": "Caral, an ancient city located approximately 200 kilometers north of Lima, Peru, is one of the oldest urban centers in the Americas, founded around 2600 B.C. and flourishing for over a millennium. At its peak, it covered more than 60 hectares and housed thousands of residents. The city was meticulously planned, featuring complex residential units, six large pyramidal structures, and an intricate irrigation system for agriculture. Caral served as a significant trade hub, connecting the Peruvian coast with the Andean highlands, as evidenced by marine shell beads and remnants of distant plants and animals. Additionally, archaeological findings, including musical instruments and the city's astronomical alignment, underscore its cultural complexity and influence. Notably, the absence of warfare artifacts suggests Caral maintained its prominence through trade and cultural development. The city's decline around 1800 B.C. is attributed to possible environmental changes and shifts in trade routes. \n\nWhat likely contributed to the decline of Caral?",
    "examen": "TOEFL",
    "opciones": ["A. Overpopulation and excessive urban sprawl.", "B. Environmental changes and shifts in trade routes.", "C. Invasion by neighboring city-states.", "D. A sudden lack of natural resources."],
    "respuesta": "B",
    "tipo": "Reading"
  },
  {
    "enunciado": "Cahokia, a major medieval town near modern-day St. Louis, Missouri, was the largest settlement of the Mississippian culture, thriving from approximately 600 AD to 1400 AD. Established around 1050 AD, it housed up to 20,000 inhabitants at its peak, spanning over 16 square kilometers and featuring about 120 earthen mounds, including the prominent Monks Mound. Strategically located at the confluence of the Mississippi, Missouri, and Illinois Rivers, Cahokia served as a vital trade hub, with artifacts such as copper, seashells, and obsidian indicating extensive trade networks across North America. Renowned for its advanced engineering and urban planning, the city boasted a grid system, woodhenge sun calendars, and expansive agricultural fields. Despite its prominence, Cahokia experienced a sudden decline in the 14th century, with potential factors including environmental degradation and societal issues like political instability or warfare.\n\nWhat is indicated by the presence of goods from distant regions in Cahokia?",
    "examen": "TOEFL",
    "opciones": ["A. The town was a recipient of international aid.", "B. Cahokia was a major trading hub.", "C. The inhabitants traveled extensively across continents.", "D. Cahokia was isolated from other cultural groups."],
    "respuesta": "B",
    "tipo": "Reading"
  },
  {
    "enunciado": "Cahokia, a major medieval town near modern-day St. Louis, Missouri, was the largest settlement of the Mississippian culture, thriving from approximately 600 AD to 1400 AD. Established around 1050 AD, it housed up to 20,000 inhabitants at its peak, spanning over 16 square kilometers and featuring about 120 earthen mounds, including the prominent Monks Mound. Strategically located at the confluence of the Mississippi, Missouri, and Illinois Rivers, Cahokia served as a vital trade hub, with artifacts such as copper, seashells, and obsidian indicating extensive trade networks across North America. Renowned for its advanced engineering and urban planning, the city boasted a grid system, woodhenge sun calendars, and expansive agricultural fields. Despite its prominence, Cahokia experienced a sudden decline in the 14th century, with potential factors including environmental degradation and societal issues like political instability or warfare.\n\nWhich feature of Cahokia reflects its advanced engineering and planning?",
    "examen": "TOEFL",
    "opciones": ["A. The location near three rivers.", "B. The use of woodhenge sun calendars and a grid system.", "C. The decline in the 14th century.", "D. The presence of 120 residential buildings."],
    "respuesta": "B",
    "tipo": "Reading"
  },
  {
    "enunciado": "Cahokia, a medieval town near modern-day St. Louis, was the largest urban settlement of the Mississippian culture, thriving from A.D. 600 to 1400. At its peak, it had up to 20,000 inhabitants and covered 16 square kilometers, featuring 120 earthen mounds, including the massive Monks Mound. Located near major rivers, Cahokia was a trade hub, exchanging goods like copper, seashells, and obsidian. It had advanced urban planning, including a grid system and agricultural fields. However, its decline in the 14th century remains debated, with theories pointing to environmental degradation (deforestation, floods) and societal factors (political instability, warfare). What are possible reasons for Cahokia’s decline?",
    "examen": "TOEFL",
    "opciones": ["A. Invasion by European settlers.", "B. Environmental and societal challenges.", "C. Lack of trade networks.", "D. Overpopulation leading to famine."],
    "respuesta": "B",
    "tipo": "Reading"
  },
  {
    "enunciado": "Paleontologists have debated that dinosaur extinction was likely due to climatic shifts linked to plate tectonics. During the Cretaceous, shallow seas covered continents, stabilizing temperatures. At the end of the Cretaceous, seas receded, causing severe climate shifts. Dinosaurs may have gone extinct due to these changes, but cold-blooded animals survived. Critics argue that shallow seas had receded before without causing extinction. Scientists then found high iridium levels in a clay layer, suggesting an asteroid impact caused rapid extinction. What was the initial hypothesis regarding the extinction of the dinosaurs according to the passage?",
    "examen": "TOEFL",
    "opciones": ["A) A giant asteroid impact ended the dinosaur era.", "B) Dinosaurs could not adapt to severe temperature fluctuations.", "C) Climatic changes due to the movement of continents and seas.", "D) A sudden increase in volcanic activity."],
    "respuesta": "C",
    "tipo": "Reading"
  },
  {
    "enunciado": "Paleontologists have debated that dinosaur extinction was likely due to climatic shifts linked to plate tectonics. During the Cretaceous, shallow seas covered continents, stabilizing temperatures. At the end of the Cretaceous, seas receded, causing severe climate shifts. Dinosaurs may have gone extinct due to these changes, but cold-blooded animals survived. Critics argue that shallow seas had receded before without causing extinction. Scientists then found high iridium levels in a clay layer, suggesting an asteroid impact caused rapid extinction. Why do critics find the climate change hypothesis insufficient to explain the extinction of dinosaurs?",
    "examen": "TOEFL",
    "opciones": ["A) Dinosaurs were able to survive previous climatic fluctuations.", "B) There is no evidence of climatic changes during the Cretaceous period.", "C) Cold-blooded animals would have been affected more than dinosaurs.", "D) The geological record does not show significant climatic shifts."],
    "respuesta": "A",
    "tipo": "Reading"
  },
  {
    "enunciado": "Paleontologists have debated that dinosaur extinction was likely due to climatic shifts linked to plate tectonics. During the Cretaceous, shallow seas covered continents, stabilizing temperatures. At the end of the Cretaceous, seas receded, causing severe climate shifts. Dinosaurs may have gone extinct due to these changes, but cold-blooded animals survived. Critics argue that shallow seas had receded before without causing extinction. Scientists then found high iridium levels in a clay layer, suggesting an asteroid impact caused rapid extinction. What led scientists to propose the asteroid impact hypothesis for the extinction of dinosaurs?",
    "examen": "TOEFL",
    "opciones": ["A) Discovery of high levels of iridium in boundary clay.", "B) Evidence of severe volcanic activity at the end of the Cretaceous.", "C) Lack of fossil evidence for dinosaurs before the Cenozoic era.", "D) Observation of increased ultraviolet radiation from the sun."],
    "respuesta": "A",
    "tipo": "Reading"
  },
  {
    "enunciado": "Paleontologists have debated that dinosaur extinction was likely due to climatic shifts linked to plate tectonics. During the Cretaceous, shallow seas covered continents, stabilizing temperatures. At the end of the Cretaceous, seas receded, causing severe climate shifts. Dinosaurs may have gone extinct due to these changes, but cold-blooded animals survived. Critics argue that shallow seas had receded before without causing extinction. Scientists then found high iridium levels in a clay layer, suggesting an asteroid impact caused rapid extinction. How did the shallow seas of the Cretaceous period likely affect the climate according to the passage?",
    "examen": "TOEFL",
    "opciones": ["A) They caused extreme weather patterns and harsh winters.", "B) They led to a decrease in global temperatures.", "C) They stabilized the temperature of the nearby air.", "D) They increased humidity and caused frequent rainfall."],
    "respuesta": "C",
    "tipo": "Reading"
  },
    {
      "enunciado": "He realized that he had to...... their trust.",
      "opciones": ["A. catch", "B. win", "C. achieve", "D. receive"],
      "respuesta": "B",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "The...... this has given him into their behaviour has allowed him to dispel certain myths about bears.",
      "opciones": ["A. perception", "B. awareness", "C. insight", "D. vision"],
      "respuesta": "C",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "...... to popular belief, he contends that bears do not",
      "opciones": ["A. Opposite", "B. Opposed", "C. Contrary", "D. Contradictory"],
      "respuesta": "C",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "as much for fruit as previously supposed.",
      "opciones": ["A. care", "B. bother", "C. desire", "D. hope"],
      "respuesta": "A",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "He also...... claims that they are ferocious.",
      "opciones": ["A. concludes", "B. disputes", "C. reasons", "D. argues"],
      "respuesta": "B",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "He says that people should not be...... by behaviour such as swatting paws on the ground, as this is a defensive, rather than an aggressive, act.",
      "opciones": ["A. misguided", "B. misled", "C. misdirected", "D. misinformed"],
      "respuesta": "B",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "However, Robertson is no sentimentalist. After devoting years of his life to the bears, he is under no...... about their feelings for him.",
      "opciones": ["A. error", "B. doubt", "C. illusion", "D. impression"],
      "respuesta": "C",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "It is clear that their interest in him does not...... beyond the food he brings.",
      "opciones": ["A. expand", "B. spread", "C. widen", "D. extend"],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Did we all start talking at around the same time...... of the manner in which our brains had begun to develop?",
      "opciones": ["A. because", "B. such", "C. other", "D. may"],
      "respuesta": "A",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "One recent theory is that human beings have evolved in...... a way that we are programmed for language from the moment of birth.",
      "opciones": ["A. because", "B. such", "C. other", "D. may"],
      "respuesta": "B",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "In...... words, language came about as a result of an evolutionary change in our brains at some stage.",
      "opciones": ["A. because", "B. such", "C. other", "D. may"],
      "respuesta": "C",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Language...... well be programmed into the brain but,...... this, people still need stimulus from others around them.",
      "opciones": ["A. because", "B. such", "C. other", "D. may"],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "but,...... this, people still need stimulus from others around them.",
      "opciones": ["A. because", "B. such", "C. other", "D. may"],
      "respuesta": "E",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "From studies, we know that...... children are isolated from human contact and have not learnt to construct sentences before they are ten, it is doubtful they will ever do so.",
      "opciones": ["A. because", "B. such", "C. other", "D. may"],
      "respuesta": "F",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "This research shows, if...... else, that language is a social activity, not something invented...... isolation.",
      "opciones": ["A. because", "B. such", "C. other", "D. may"],
      "respuesta": "G",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "not something invented...... isolation.",
      "opciones": ["A. because", "B. such", "C. other", "D. may"],
      "respuesta": "H",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "To guarantee that opponents can be......",
      "opciones": ["A. overcome", "B. fitness", "C. endurance", "D. beneficial"],
      "respuesta": "A",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "a rigorous and comprehensive...... regime and a highly nutritious diet are vital for top-level performance.",
      "opciones": ["A. overcome", "B. fitness", "C. endurance", "D. beneficial"],
      "respuesta": "B",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "provide athletes with the...... they need to compete.",
      "opciones": ["A. overcome", "B. fitness", "C. endurance", "D. beneficial"],
      "respuesta": "C",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "pasta is more...... than eggs or meat.",
      "opciones": ["A. overcome", "B. fitness", "C. endurance", "D. beneficial"],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Failure to follow a sensible diet can result in the...... to maintain stamina.",
      "opciones": ["A. overcome", "B. fitness", "C. endurance", "D. beneficial"],
      "respuesta": "E",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Regular training to increase muscular...... is also a vital part of a professional’s regime,",
      "opciones": ["A. overcome", "B. fitness", "C. endurance", "D. beneficial"],
      "respuesta": "F",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "and this is...... done by exercising with weights.",
      "opciones": ["A. overcome", "B. fitness", "C. endurance", "D. beneficial"],
      "respuesta": "G",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "the...... of these can be minimised.",
      "opciones": ["A. overcome", "B. fitness", "C. endurance", "D. beneficial"],
      "respuesta": "H",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "My brother now earns far less than he did when he was younger.",
      "opciones": ["A. nearly as much", "B. almost as much", "C. not as much", "D. as much as"],
      "respuesta": "A",
      "tipo": "Use of English",
      "examen": "CAE"
    },
    {
      "enunciado": "They are demolishing the old bus station and replacing it with a new one.",
      "opciones": ["A. pulled down", "B. being pulled", "C. pull down", "D. pulled in"],
      "respuesta": "C",
      "tipo": "Use of English",
      "examen": "CAE"
    },
    {
      "enunciado": "The number of students now at university has reached an all-time high, apparently.",
      "opciones": ["A. the highest ever", "B. the highest ever been", "C. the highest ever being", "D. the highest ever to be"],
      "respuesta": "A",
      "tipo": "Use of English",
      "examen": "CAE"
    },
    {
      "enunciado": "I’m disappointed with the Fishers’ new album when I compare it to their previous one.",
      "opciones": ["A. in comparison", "B. compared to", "C. when compared", "D. a disappointment in comparison"],
      "respuesta": "D",
      "tipo": "Use of English",
      "examen": "CAE"
    },
    {
      "enunciado": "Anna got the job even though she didn’t have much experience in public relations.",
      "opciones": ["A. in spite of", "B. despite of", "C. regardless of", "D. notwithstanding"],
      "respuesta": "A",
      "tipo": "Use of English",
      "examen": "CAE"
    },
    {
      "enunciado": "‘I must warn you how dangerous it is to cycle at night without any lights,’ said the police officer to Max.",
      "opciones": ["A. dangers", "B. danger", "C. dangerous", "D. dangerously"],
      "respuesta": "A",
      "tipo": "Use of English",
      "examen": "CAE"
    },
    {
      "enunciado": "What problem regarding colour does the writer explain in the first paragraph?",
      "opciones": ["A. Our view of colour is strongly affected by changing fashion.", "B. Analysis is complicated by the bewildering number of natural colours.", "C. Colours can have different associations in different parts of the world.", "D. Certain popular books have dismissed colour as insignificant."],
      "respuesta": "C",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "What is the first reason the writer gives for the lack of academic work on the history of colour?",
      "opciones": ["A. There are problems of reliability associated with the artefacts available.", "B. Historians have seen colour as being outside their field of expertise.", "C. Colour has been rather looked down upon as a fit subject for academic study.", "D. Very little documentation exists for historians to use."],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "The writer suggests that the priority when conducting historical research on colour is to",
      "opciones": ["A. ignore the interpretations of other modern day historians.", "B. focus one's interest as far back as the prehistoric era.", "C. find some way of organising the mass of available data.", "D. relate pictures to information from other sources."],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "In the fourth paragraph, the writer says that the historian writing about colour should be careful",
      "opciones": ["A. not to analyse in an old-fashioned way.", "B. when making basic distinctions between key ideas.", "C. not to make unwise predictions.", "D. when using certain terms and concepts."],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "In the fifth paragraph, the writer says there needs to be further research done on",
      "opciones": ["A. the history of colour in relation to objects in the world around us.", "B. the concerns he has raised in an earlier publication.", "C. the many ways in which artists have used colour over the years.", "D. the relationship between artistic works and the history of colour."],
      "respuesta": "A",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "An idea recurring in the text is that people who have studied colour have",
      "opciones": ["A. failed to keep up with scientific developments.", "B. not understood its global significance.", "C. found it difficult to be fully objective.", "D. been muddled about their basic aims."],
      "respuesta": "C",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Which reviewer has a different opinion from the others on the confidence with which de Botton discusses architecture?",
      "opciones": ["A. Reviewer A", "B. Reviewer B", "C. Reviewer C", "D. Reviewer D"],
      "respuesta": "B",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "shares reviewer A’s opinion whether architects should take note of de Botton’s ideas?",
      "opciones": ["A. Reviewer A", "B. Reviewer B", "C. Reviewer C", "D. Reviewer D"],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "expresses a similar view to reviewer B regarding the extent to which architects share de Botton’s concerns?",
      "opciones": ["A. Reviewer A", "B. Reviewer B", "C. Reviewer C", "D. Reviewer D"],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "has a different view to reviewer C on the originality of some of de Botton’s ideas?",
      "opciones": ["A. Reviewer A", "B. Reviewer B", "C. Reviewer C", "D. Reviewer D"],
      "respuesta": "A",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "On my living-room wall I have a painting of a western Scotland. This is a cause for real wildcat by John Holmes of which I am concern, given that the animals in these areas have less contact with domestic cats and are therefore purer.",
      "opciones": ["A. Paragraph A", "B. Paragraph B", "C. Paragraph C", "D. Paragraph D", "E. Paragraph E", "F. Paragraph F", "G. Paragraph G"],
      "respuesta": "G",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "However, the physical differences are tangible. The wildcat is a much larger animal...",
      "opciones": ["A. Paragraph A", "B. Paragraph B", "C. Paragraph C", "D. Paragraph D", "E. Paragraph E", "F. Paragraph F", "G. Paragraph G"],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "However, things were later to improve for the species.",
      "opciones": ["A. Paragraph A", "B. Paragraph B", "C. Paragraph C", "D. Paragraph D", "E. Paragraph E", "F. Paragraph F", "G. Paragraph G"],
      "respuesta": "A",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "The current research aims to resolve this potential problem.",
      "opciones": ["A. Paragraph A", "B. Paragraph B", "C. Paragraph C", "D. Paragraph D", "E. Paragraph E", "F. Paragraph F", "G. Paragraph G"],
      "respuesta": "F",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "But what of his lifestyle? Wildcat kittens are usually born in May/June in a secluded den...",
      "opciones": ["A. Paragraph A", "B. Paragraph B", "C. Paragraph C", "D. Paragraph D", "E. Paragraph E", "F. Paragraph F", "G. Paragraph G"],
      "respuesta": "E",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Rabbits are a favourite prey, and some of the best areas to see wildcats are at rabbit warrens close to the forest and moorland edge.",
      "opciones": ["A. Paragraph A", "B. Paragraph B", "C. Paragraph C", "D. Paragraph D", "E. Paragraph E", "F. Paragraph F", "G. Paragraph G"],
      "respuesta": "B",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Which consultant makes the following statement? 'Keep your final objective in mind when you are planning to change jobs.'",
      "opciones": ["A. Consultant A", "B. Consultant B", "C. Consultant C", "D. Consultant D", "E. Consultant E"],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "It takes time to become familiar with the characteristics of a company you have joined.",
      "opciones": ["A. Consultant A", "B. Consultant B", "C. Consultant C", "D. Consultant D", "E. Consultant E"],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "You should demonstrate determination to improve your job prospects.",
      "opciones": ["A. Consultant A", "B. Consultant B", "C. Consultant C", "D. Consultant D", "E. Consultant E"],
      "respuesta": "C",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Make sure your approach for information is positive in tone.",
      "opciones": ["A. Consultant A", "B. Consultant B", "C. Consultant C", "D. Consultant D", "E. Consultant E"],
      "respuesta": "A",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "It is not certain that you will be given very much support in your job initially.",
      "opciones": ["A. Consultant A", "B. Consultant B", "C. Consultant C", "D. Consultant D", "E. Consultant E"],
      "respuesta": "D",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Stay optimistic in spite of setbacks.",
      "opciones": ["A. Consultant A", "B. Consultant B", "C. Consultant C", "D. Consultant D", "E. Consultant E"],
      "respuesta": "B",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Promotion isn’t the only way to increase your expertise.",
      "opciones": ["A. Consultant A", "B. Consultant B", "C. Consultant C", "D. Consultant D", "E. Consultant E"],
      "respuesta": "C",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Ask for information about your shortcomings.",
      "opciones": ["A. Consultant A", "B. Consultant B", "C. Consultant C", "D. Consultant D", "E. Consultant E"],
      "respuesta": "A",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "Some information you are given may not give a complete picture.",
      "opciones": ["A. Consultant A", "B. Consultant B", "C. Consultant C", "D. Consultant D", "E. Consultant E"],
      "respuesta": "B",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
      "enunciado": "It will be some time before you start giving your employers their money’s worth.",
      "opciones": ["A. Consultant A", "B. Consultant B", "C. Consultant C", "D. Consultant D", "E. Consultant E"],
      "respuesta": "E",
      "tipo": "Reading",
      "examen": "CAE"
    },
    {
        "enunciado": "Some days I just want to give up. - Come on Don't throw the towel yet.",
        "opciones": ["A. out", "B. up", "C. in", "D. down"],
        "respuesta": "C",
        "tipo": "Grammar",
        "examen": "MET"
    },
    {
        "enunciado": "Where are my socks? In the suitcase you put your shoes in.",
        "opciones": ["A. that", "B. where", "C. in which", "D. in that"],
        "respuesta": "A",
        "tipo": "Grammar",
        "examen": "MET"
    },
    {
        "enunciado": "Did Emily apologize after the argument? No, but she do so soon.",
        "opciones": ["A. had better", "B. would rather", "C. better had to", "D. should rather"],
        "respuesta": "A",
        "tipo": "Grammar",
        "examen": "MET"
    },
    {
        "enunciado": "Did you believe Janet's story? - No, I'm afraid it water.",
        "opciones": ["A. will hold", "B. held", "C. doesn't hold", "D. is holding"],
        "respuesta": "C",
        "tipo": "Grammar",
        "examen": "MET"
    },
    {
        "enunciado": "Anna has a knack for art. painting, she can also draw.",
        "opciones": ["A. apart", "B. except", "C. instead", "D. besides"],
        "respuesta": "D",
        "tipo": "Grammar",
        "examen": "MET"
    },
    {
        "enunciado": "Ellen is so moody in the morning that you should never attempt to speak to her until the afternoon.",
        "opciones": ["A. temperamental", "B. commercial", "C. trend", "D. hamlet"],
        "respuesta": "A",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "The current in fashion indicates that bright colors will be in style this year.",
        "opciones": ["A. potential", "B. vindication", "C. trend", "D. hamlet"],
        "respuesta": "C",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "Thanks to the cooperation of fire departments from the surrounding cities, the blaze was stopped in time.",
        "opciones": ["A. proliferation", "B. evaluation", "C. conjugation", "D. collaboration"],
        "respuesta": "D",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "Anyone wishing to work as an intelligence agent for the Federal Bureau of Investigation must first undergo a background investigation.",
        "opciones": ["A. tiny", "B. handy", "C. stringent", "D. stingy"],
        "respuesta": "C",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "If you approach the job with eagerness, you should be able to finish it more quickly.",
        "opciones": ["A. alacrity", "B. reluctance", "C. vulgarity", "D. wholesomeness"],
        "respuesta": "A",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "Which of the following statements concerning national networks is true?",
        "opciones": ["A) Networks are reliant upon businesses for monetary support.", "B) The network's success depends upon the public's viewing habits.", "C) The national network is also known as the National Broadcasting Corporation.", "D) Families do not pay a fee to watch national television."],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "MET"
    },
    {
        "enunciado": "Television programs",
        "opciones": ["A) are few and far between.", "B) are broadcast during purchased airtime.", "C) are constantly being altered.", "D) are free of charge to the public."],
        "respuesta": "D",
        "tipo": "Reading",
        "examen": "MET"
    },
    {
        "enunciado": "The public's viewing habits",
        "opciones": ["A) are assessed by the Nielsen Ratings.", "B) are constant and unwavering.", "C) are influenced by advertising.", "D) fluctuate in relation to commercial support."],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "MET"
    },
    {
        "enunciado": "An advertiser will communicate his message to the largest amount of people",
        "opciones": ["A) when the Nielsen Rating increases.", "B) during Prime Time.", "C) in the morning.", "D) in the afternoon."],
        "respuesta": "B",
        "tipo": "Reading",
        "examen": "MET"
    },
    {
        "enunciado": "Commercial opportunities are",
        "opciones": ["A) most plentiful during the broadcast of soap opera episodes.", "B) thwarted by statistical ratios compiled by Nielsen.", "C) the best during Prime Time.", "D) greater during the morning than during the afternoon."],
        "respuesta": "C",
        "tipo": "Reading",
        "examen": "MET"
    },
        {
        "enunciado": "What is the meaning of 'magnify'?",
        "opciones": ["A. reduce", "B. enlarge", "C. diminish", "D. compress"],
        "respuesta": "B",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "What is the meaning of 'innovation'?",
        "opciones": ["A. tradition", "B. invention", "C. routine", "D. habit"],
        "respuesta": "B",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "What is the meaning of 'precise'?",
        "opciones": ["A. vague", "B. exact", "C. ambiguous", "D. unclear"],
        "respuesta": "B",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "What is the meaning of 'constitute'?",
        "opciones": ["A. destroy", "B. consist", "C. dismantle", "D. break"],
        "respuesta": "B",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "What is the meaning of 'emitting'?",
        "opciones": ["A. absorbing", "B. giving off", "C. retaining", "D. holding"],
        "respuesta": "B",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "What is the meaning of 'apparatus'?",
        "opciones": ["A. mechanism", "B. disarray", "C. chaos", "D. disorder"],
        "respuesta": "A",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "What is the meaning of 'accelerated'?",
        "opciones": ["A. slowed", "B. quicken", "C. delayed", "D. hindered"],
        "respuesta": "B",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "What is the meaning of 'naked'?",
        "opciones": ["A. covered", "B. bare", "C. clothed", "D. dressed"],
        "respuesta": "B",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "What is the meaning of 'specimen'?",
        "opciones": ["A. sample", "B. whole", "C. entirety", "D. collection"],
        "respuesta": "A",
        "tipo": "Vocabulary",
        "examen": "MET"
    },
    {
        "enunciado": "Genealogy is a (0) …….. of history. It concerns family history, (1) …….. than the national or world history studied at school.",
        "opciones": ["A. instead", "B. rather", "C. except", "D. sooner"],
        "respuesta": "B",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "The internet enables millions of people worldwide to (3) …….. information about their family history, without great (4) ……… .",
        "opciones": ["A. accomplish", "B. access", "C. approach", "D. admit"],
        "respuesta": "B",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "People who research their family history often (5) …….. that it’s a fascinating hobby which (6) ……..... a lot about where they come from and whether they have famous ancestors.",
        "opciones": ["A. describe", "B. define", "C. remark", "D. regard"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "The survey also concluded that the (7) …….. back you follow your family line, the more likely you are to find a relation who was much wealthier than you are.",
        "opciones": ["A. older", "B. greater", "C. higher", "D. further"],
        "respuesta": "D",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "However, the vast majority of people who (8) …….. in the survey discovered they were better off than their ancestors.",
        "opciones": ["A. attended", "B. participated", "C. included", "D. associated"],
        "respuesta": "B",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "I work (0) ...... a motorbike stunt rider – that is, I do tricks on my motorbike at shows.",
        "opciones": ["A. as", "B. like", "C. for", "D. with"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "The Le Mans race track in France was (9) …….. I first saw some guys doing motorbike stunts.",
        "opciones": ["A. where", "B. when", "C. which", "D. that"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "I’d never seen anyone riding a motorbike using just the back wheel before and I was (10) …….. impressed I went straight home and taught (11) …….. to do the same.",
        "opciones": ["A. so", "B. such", "C. very", "D. too"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "I have a degree (12) …….. mechanical engineering; this helps me to look at the physics (13) …….. lies behind each stunt.",
        "opciones": ["A. in", "B. on", "C. with", "D. for"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "In addition to being responsible for design changes to the motorbike, I have to work (14) …….. every stunt I do.",
        "opciones": ["A. out", "B. on", "C. in", "D. up"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "Archaeologists (0) …….. that a perfectly preserved 5,500-year-old shoe has been discovered in a cave in Armenia in south-west Asia.",
        "opciones": ["A. accepted", "B. regarded", "C. assessed", "D. believed"],
        "respuesta": "D",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "The shoe was made of a single piece of leather, stitched at the front and back, and was shaped to fit the wearer’s foot. It had been (2) …….. with grasses, either for warmth or to make sure it kept its shape.",
        "opciones": ["A. stuffed", "B. loaded", "C. pushed", "D. blocked"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "‘The shoe is relatively small but we can’t say for (3) whether it was worn by a man or a woman,’ says Dr Ron Pinhasi, an archaeologist on the research (4) ......",
        "opciones": ["A. clear", "B. specific", "C. true", "D. certain"],
        "respuesta": "D",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "Shoes of this type from later periods have turned (5) …….. in archaeological excavations in various places in Europe, and shoes of a very similar design were still being used on the Aran Islands off the west coast of Ireland as (6) …….. as the 1950s.",
        "opciones": ["A. over", "B. into", "C. up", "D. about"],
        "respuesta": "C",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "It’s (7) …….. a style which (8) …….. popular for thousands of years.",
        "opciones": ["A. correctly", "B. exactly", "C. precisely", "D. obviously"],
        "respuesta": "D",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "In the 15th century, Europeans knew nothing of the chilli pepper, but they held black pepper in high regard and had used it in cooking (0) …….. Greek and Roman times.",
        "opciones": ["A. since", "B. for", "C. from", "D. during"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "Ships travelling east brought the black pepper from the Spice Islands in South East Asia but this (9) …..... a long time.",
        "opciones": ["A. took", "B. spent", "C. lasted", "D. passed"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "In 1492, Christopher Columbus was asked to find a shorter route to the Spice Islands, going westwards (10) …..... than eastwards, and so he set (11)......from Spain across the Atlantic Ocean.",
        "opciones": ["A. rather", "B. instead", "C. better", "D. sooner"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "Columbus didn’t succeed (12) …….. finding the Spice Islands but he (13)......manage to reach the Americas.",
        "opciones": ["A. in", "B. on", "C. at", "D. with"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    },
    {
        "enunciado": "There he (14)...... across another pepper; the chilli, which had been used in cooking in South America for thousands of years.",
        "opciones": ["A. came", "B. went", "C. ran", "D. found"],
        "respuesta": "A",
        "tipo": "Reading",
        "examen": "FCE"
    }
];

// Función para agregar múltiples preguntas a Firestore
Future<void> addMultipleQuestions() async {
  await initializeFirebase(); // Asegúrate de que Firebase esté inicializado

  final firestore = FirebaseFirestore.instance;
  final preguntasCollection = firestore.collection("preguntas");
  final batch = firestore.batch();

  for (var questionData in nuevasPreguntas) {
    final newDocRef = preguntasCollection.doc();
    batch.set(newDocRef, questionData);
  }

  try {
    await batch.commit();
    print("Preguntas agregadas exitosamente.");
  } catch (error) {
    print("Error al agregar preguntas: $error");
  }
}

void main() async {
  await initializeFirebase();
  await addMultipleQuestions();
  // ... resto del código de tu aplicación ...
}