package CIF::Msg;
# Generated by the protocol buffer compiler (protoc-perl) DO NOT EDIT!
# source: /home/wes/projects/src/cif/v1/cif-v1/libcif/sbin/../protocol/src/msg.proto



use strict;
use warnings;

use Google::ProtocolBuffers;
{
    unless (MessageType::StatusType->can('_pb_fields_list')) {
        Google::ProtocolBuffers->create_enum(
            'MessageType::StatusType',
            [
               ['SUCCESS', 1],
               ['FAILED', 2],
               ['UNAUTHORIZED', 3],

            ]
        );
    }
    
    unless (MessageType::MsgType->can('_pb_fields_list')) {
        Google::ProtocolBuffers->create_enum(
            'MessageType::MsgType',
            [
               ['QUERY', 1],
               ['SUBMISSION', 2],
               ['REPLY', 3],

            ]
        );
    }
    
    unless (MessageType::QueryType->can('_pb_fields_list')) {
        Google::ProtocolBuffers->create_message(
            'MessageType::QueryType',
            [
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_STRING(), 
                    'apikey', 1, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_STRING(), 
                    'guid', 2, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_INT32(), 
                    'limit', 3, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_INT32(), 
                    'confidence', 4, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_REPEATED(), 
                    'MessageType::QueryStruct', 
                    'query', 5, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_STRING(), 
                    'description', 6, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_BOOL(), 
                    'feed', 7, 0
                ],

            ],
            { 'create_accessors' => 1, 'follow_best_practice' => 1,  }
        );
    }

    unless (MessageType::SubmissionType->can('_pb_fields_list')) {
        Google::ProtocolBuffers->create_message(
            'MessageType::SubmissionType',
            [
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_STRING(), 
                    'guid', 1, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_REPEATED(), 
                    Google::ProtocolBuffers::Constants::TYPE_BYTES(), 
                    'data', 2, undef
                ],

            ],
            { 'create_accessors' => 1, 'follow_best_practice' => 1,  }
        );
    }

    unless (MessageType->can('_pb_fields_list')) {
        Google::ProtocolBuffers->create_message(
            'MessageType',
            [
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    Google::ProtocolBuffers::Constants::TYPE_STRING(), 
                    'version', 1, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    'MessageType::MsgType', 
                    'type', 2, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    'MessageType::StatusType', 
                    'status', 3, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_STRING(), 
                    'apikey', 4, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_REPEATED(), 
                    Google::ProtocolBuffers::Constants::TYPE_BYTES(), 
                    'data', 5, undef
                ],

            ],
            { 'create_accessors' => 1, 'follow_best_practice' => 1,  }
        );
    }

    unless (MessageType::QueryStruct->can('_pb_fields_list')) {
        Google::ProtocolBuffers->create_message(
            'MessageType::QueryStruct',
            [
                [
                    Google::ProtocolBuffers::Constants::LABEL_REQUIRED(), 
                    Google::ProtocolBuffers::Constants::TYPE_STRING(), 
                    'query', 1, undef
                ],
                [
                    Google::ProtocolBuffers::Constants::LABEL_OPTIONAL(), 
                    Google::ProtocolBuffers::Constants::TYPE_BOOL(), 
                    'nolog', 2, undef
                ],

            ],
            { 'create_accessors' => 1, 'follow_best_practice' => 1,  }
        );
    }

}
1;
