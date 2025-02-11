export const CRIMESTATUS2COLOR = {
  Arrest: 'bad',
  Discharged: 'good',
  Incarcerated: 'average',
  Parole: 'blue',
  Suspected: 'purple',
} as const;

export const CRIMESTATUS2DESC = {
  Arrest: 'Arreté. La cible doit avoir commit un crime valable pour recevoir ce statut.',
  Discharged: 'Innocenté. La cible a été innocenté.',
  Incarcerated: 'Enfermé. La cible a été enfermé pour son crime.',
  Parole: 'Libéré sous conditionnelle. La cible est libre mais sous supervision.',
  Suspected: 'Suspecté. Surveille de près la cible pour découvrire toute activitée illégales.',
} as const;
