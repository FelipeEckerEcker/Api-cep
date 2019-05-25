class BuscaCepController < ApplicationController
    require 'net/http'
    require 'json'

    def buscar
        /begin/
        debugger
        @cep = cep_params[:cep]
        url = "https://viacep.com.br/ws/#{@cep}/json/"
        
        retorno = JSON.parse(Net::HTTP.get(URI(url)))
         debugger
         estado = Estado.find_or_initialize_by(uf: retorno["uf"])
         estado.save

         cidade = Cidade.find_or_initialize_by(nome: retorno["localidade"], estado_id: estado.id)
         cidade.save

         endereco = Endereco.find_or_initialize_by(cep: retorno["cep"])
         endereco.logradouro = retorno["logradouro"]
         endereco.bairro = retorno["bairro"]
         endereco.complemento = retorno["complemento"]  
         endereco.save

        render json: {endereco: endereco, cidade: cidade} status: :ok
    end

    private 

    def cep_params
        params.permit(:cep)
    end

end
