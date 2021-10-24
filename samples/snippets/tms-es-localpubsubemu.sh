#!/bin/bash


#gcloud components install pubsub-emulator
#gcloud components update

exportPubSubEmuHost="PUBSUB_EMULATOR_HOST=localhost:8085"
exportPubSubProjId="PUBSUB_PROJECT_ID=local-tms-es-gcp-pubsub"
exportPubSubTopicId="TOPIC_ID=dk_tms_esearch"
exportPubSubSubscriptionId="SUB_ID=dk_tms_esearch_sub"
exportPubSubDLTopicId="DLT_TOPIC_ID=dk_tms_esearch_sub_dead"

start_localpubsubemu () {
  kill $(lsof -t -i:8085)
  export $exportPubSubEmuHost
  export $exportPubSubProjId
  export $exportPubSubTopicId
  gcloud beta emulators pubsub start

}

create_topic () {
  export $exportPubSubEmuHost
  export $exportPubSubProjId
  export $exportPubSubTopicId
  python publisher.py $PUBSUB_PROJECT_ID create $TOPIC_ID
  exit 0
}

create_deadlettertopic () {
  export $exportPubSubEmuHost
  export $exportPubSubProjId
  export $exportPubSubDLTopicId
  python publisher.py $PUBSUB_PROJECT_ID create $DLT_TOPIC_ID
  exit 0
}

create_subscriptionIdWithDLT () {
  export $exportPubSubEmuHost
  export $exportPubSubProjId
  export $exportPubSubTopicId
  export $exportPubSubDLTopicId
  export $exportPubSubSubscriptionId
  python subscriber.py $PUBSUB_PROJECT_ID create-with-dead-letter-policy $TOPIC_ID $SUB_ID $DLT_TOPIC_ID 10
}

#publish_messages () {
#  export $exportPubsubProjId
#  export $exportPubsubProjId
#  python publisher.py PUBSUB_PROJECT_ID publish TOPIC_ID
#}


start_localpubsubemu & ( create_topic ) & ( create_deadlettertopic ) && ( create_subscriptionIdWithDLT )

