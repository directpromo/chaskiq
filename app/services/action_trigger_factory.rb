class ActionTriggerFactory 

  attr_accessor :id, :after_delay, :paths

  def initialize
    @id
    @paths = []
  end
  
  def config()
    yield(self)
  end

  def path(title: "" , follow_actions: [] , steps: [])
    @paths << {title: title, follow_actions: follow_actions, steps: steps}
  end

  def message(text:, uuid:)
     
      { 
        "step_uid": uuid,
        "type":"messages",
        "messages":[ 
          { 
            "app_user":{ 
              "display_name":"chaskiq bot",
              "email":"bot@chaskiq.io",
              "id":1,
              "kind":"agent"
            },
            "serialized_content":"{\"blocks\":[{\"key\":\"9oe8n\",\"text\":\"#{text}\",\"type\":\"unstyled\",\"depth\":0,\"inlineStyleRanges\":[],\"entityRanges\":[],\"data\":{}}],\"entityMap\":{}}",
            "html_content":"hola"
          }
        ]
      }
    
  end

  def controls(schema: [], wait_for_input: true, uuid:, type: )
    { 
      "step_uid": uuid,
      "type":"messages",
      "messages":[ 

      ],
      "controls":{ 
        "type":type,
        "schema": schema,
        "wait_for_input":wait_for_input
      }
    }
  end

  def button(text: , next_uuid:)
    { 
      "id":"a67d247d-7b81-4f87-b172-e8b87371d921",
      "element":"button",
      "label": text,
      "next_step_uuid": next_uuid
    }
  end

  def input(label:, name:, placeholder: "")
    {
      element: "input",
      id: "",
      name: name,
      label: label,
      placeholder: placeholder,
      type: "text"
    }

  end

  def assign(id)
    { 
      "key":"assign",
      "name":"assign",
      "value":id
    }
  end

  def close()
    { 
      "key":"close",
      "name":"close"
    }
  end

  def to_obj
    JSON.parse(self.to_json, object_class: OpenStruct)
  end

  def self.request_for_email(app:)
    subject = ActionTriggerFactory.new
    subject.config do |c|
      c.id = "request_for_email"
      c.after_delay = 2
      c.path(
        title: "request_for_email" , 
        steps: [
          c.message(text: "#{app.name} will reply as soon as they can.", uuid: 1),
          c.controls(
            uuid: 2,
            type: "data_retrieval",
            schema: [
              c.input(
                label: "enter your email", 
                name: "email", 
                placeholder: "enter your email"
              )
            ]
          ),
          c.message(text: "molte gratzie", uuid: 3),
        ],
        follow_actions: [c.assign(10)],
      )
    end

    subject
  end


end