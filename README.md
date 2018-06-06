# Chatter
Real time chat app written in Swift 4 using Firebase

# Push Notifications using Cloud Functions

``` js

// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();


exports.notification = functions.database
	.ref('conversations/{conversationsID}/{messageID}')
	.onCreate((snapshot, context) => {
		var sender = snapshot.val().sender;
		var receiver = snapshot.val().receiver;
		var content = '';

		if (snapshot.val().data.text) {
			content = snapshot.val().data.text;
		}

		const conversationsID = context.params.conversationsID;
		const messageID = context.params.messageID;

		var topic = receiver.id;

		// Notification details and Payload.
		const payload = {
			notification: {
				title: sender.displayName,
				body: content,
				sound: 'default'
			},
			data: {
				statusCode: '101',
				senderID: sender.id,
				senderName: sender.displayName,
				receiverID: receiver.id,
				receiverName: receiver.displayName,
				conversationsID: conversationsID,
				messageID: messageID,
				content: content,
				senderImage: sender.image,
				receiverImage: receiver.image,
				type: 'SINGLE'
			}
		};

		if (snapshot.val().data.photo) {
			payload.data['image-url'] = snapshot.val().data.photo;
			payload.data['mediaUrl'] = snapshot.val().data.photo;
		}

		const options = {
			priority: 'high',
			timeToLive: 60 * 60 * 24
		};

		if (snapshot.val().data.photo) {
			options['content_available'] = true;
			options['mutable_content'] = true;
		}

		return admin.messaging().sendToTopic(topic, payload, options);
	});


```
