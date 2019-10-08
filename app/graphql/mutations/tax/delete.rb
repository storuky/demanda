module Mutations
  module Tax
    class Delete < Mutations::AuthorisedMutation
      graphql_name 'DeleteTax'

      argument :id, String, required: true

      field :errors, [String], null: true
      field :message, String, null: false

      def resolve(id:)
        authorise_user
        tax = current_account.taxes.find_by(uuid: id)

        tax.destroy
        {
          errors: [],
          message: 'Tax was deleted'
        }
      end
    end
  end
end
