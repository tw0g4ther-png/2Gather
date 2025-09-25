import * as admin from 'firebase-admin'

admin.initializeApp()

export * from './trigggers/index';
export * from './callables/index';