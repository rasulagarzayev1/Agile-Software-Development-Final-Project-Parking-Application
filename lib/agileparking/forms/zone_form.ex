defmodule Agileparking.Forms.Zoneform do
    use Ecto.Schema
    import Ecto.Changeset

  
    schema "" do
        field :name, :string, virtual: true
    end
  
    def changeset(model, params \\ :empty) do
      model
      |> cast(params, [:name])
      #|> validate_length(:body, min: 5) - any validations, etc. 
    end   
  end