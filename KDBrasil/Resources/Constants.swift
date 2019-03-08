//
//  Constants.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-25.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

enum LocalizationKeys {
    //Menu
    static let menuHome = "Página inicial"
    static let menuSettings = "Configuração"
    
    //Settings
    static let settingsAccount = "Perfil"
    static let settingsShare = "Contar para um amigo"
    static let settingsContactUs = "Fale conosco"
    static let settingsDonate = "Apoie esse projeto"
    static let settingsTermsOfUse = "Termos de uso"
    static let settingsPrivacy = "Política de privacidade"
    static let settingsAbout = "Sobre"
    
    //Account
    static let buttonLogin = "  Entrar"
    static let buttonLogout = "  Sair"
    static let accountName = "Visitante"
    static let accountEditProfile = "Editar Perfil"
    static let accountDeleteProfile = "Deletar Minha Conta"
    static let imageUserDefault = "user"
    static let accessProfile = "É necessário estar conectado para ter acesso ao Perfil."
    static let updateProfile = "Os dados foram atualizados com sucesso."
    
    //ButtonsDefault
    static let buttonCancel = "Cancelar"
    static let buttonSave = "Salvar"
    static let buttonDone = "Finalizar"
    static let buttonContinue = "Continuar"
    static let buttonOK = "OK"
    
    //PickImage
    static let buttonCamera = "Tirar Foto"
    static let buttonPhotoLibrary = "Escolher Foto"
    
    //MyBusinessViewController
    static let buttonSelectCategory = "Selecionar"
    
    //Activity Indicator
    static let pleaseWait = "Por favor, aguarde um momento..."
    
    //Week
    static let monday = "segunda-feira"
    static let tuesday = "terça-feira"
    static let wednesday = "quarta-feira"
    static let thursday = "quinta-feira"
    static let friday = "sexta-feira"
    static let saturday = "sábado"
    static let sunday = "domingo"
    
    //Term of use
    static let termOfUse = "O aplicativo KD Brasil tem como objetivo a divulgação, informação e aproximação de clientes e prestadores de serviços. O KD Brasil é uma plataforma criada com o intuito de otimizar o contato inicial entre prestadores de serviços, previamente cadastrados no aplicativo, e consumidor final. \n\nA utilização deste aplicativo é gratuita para o usuário. Ao instalar o app e concordar com o presente Termo de Uso, o usuário entende que poderá receber notificações e ter sua localização determinada pelo KD Brasil. \n\nO usuário não pode utilizar o aplicativo para qualquer finalidade ilegal ou não autorizada. Você concorda em cumprir todas as leis, regras e regulamentações (por exemplo, federal estadual e municipal) aplicáveis ao seu uso do KD Brasil e seu conteúdo, incluindo, mas não limitado a leis de direitos autorais."
    
    //Share App
    static let shareApp = "Você já conhece o app KD Brasil? Não? 😱😱\nSe liga na novidade e encontre o serviço que você mais precisa.\nBaixe agora, é grátis! \nhttps://itunes.apple.com/ca/app/kd-brasil/id1454261196?mt=8"
    
}

enum periodOfDay {
    //set the values to show into menu-profile
    static let goodMorging = "Bom dia,"
    static let goodAfternoon = "Boa tarde,"
    static let goodEvening = "Boa noite,"
}

enum Coordinates {
    //set coordinates from Montreal - approximate
    static let latitude = 45.5576996
    static let longitude = -74.0104841
}

enum Placeholders {
    static let placeholder_photo = "placeholder_photo"
    static let placeholder_descricao = "Escreva aqui a descrição do seu anúncio."
    static let searchByName = "Pesquisar por nome"
    static let searchByCategory = "Pesquisar por categoria"
    static let searchByCity = "Pesquisar por cidade"
}


enum General {
    static let congratulations = "Parabéns!"
    static let successfully = "A sua conta foi criada com sucesso!"
    static let OK = "OK"
    static let warning = "Aviso"
    static let errorSigingUp = "Ocorreu um erro para logar, tente novamente."
    static let warningPhotoCameraDenied = "O acesso a sua biblioteca de fotos e/ou a câmera foi negado anteriormente, por favor, vá no menu configurações do seu celular e habilite novamente."
    static let businessCreated = "Anúncio criado com sucesso."
    static let businessEdited = "Anúncio atualizado com sucesso."
    static let removeAccount = "Essa operação não poderá ser desfeita e os seus dados (perfil e anúncios) serão perdidos. Deseja continuar ?"
    static let featureUnavailable = "Recurso indisponível nessa versão."
    
}

enum CoreDataConstants{
    static let CDUser = "CDUser"
}


enum FirebaseAuthErrors {
    static let invalidEmail = "E-mail inválido."
    static let wrongPassword = "Senha incorreta."
    static let emailAlreadyInUse = "Este e-mail já está sendo usado."
    static let weakPassword = "A senha precisa ter no mínimo 6 caracteres"
    static let warning = "Atenção!"
    static let errorDefault = "É necessário preencher os campos obrigatórios."
    static let userNotFound = "Usuário não encontrado. Por favor, tente novamente!"
    static let userDisabled = "A sua conta esta desabilitada. \nEntre em contato com o administrador do sistema."
    static let networkError = "A conexão com a internet esta indisponível. \n\nVerifique e tente novamente."
}

enum CommonWarning {
    static let  passwordDontMatch = "As senhas precisam ser iguais."
    static let  passwordEmpty = "O campo senha esta vazio."
    static let  emailEmpty = "O campo e-mail esta vazio."
    static let  emailResetPassword = "Informe o e-mail da conta que deseja trocar senha."
    static let  generalError = "Ocorreu um erro, tente novamente."
    static let  emailSentResetPassword = "Um e-mail com as instruções para redefinir a senha foi enviado com sucesso. \n\nVerifique a sua caixa de entrada."
    static let  errorMessageInvalidPhone = "Telefone inválido"
    static let  errorEmail = "E-mail inválido"
    static let  errorWebSite = "URL inválida"
    static let  errorNewBusiness = "Você precisa estar conectado para cadastrar um anúncio."
    static let  errorNewReviews = "Você precisa estar conectado para avaliar esse anúncio."
}

enum API_GeoNames {
    
    private static let username = "lfoliveira"
    static let url_searchJSON_default = "http://api.geonames.org/searchJSON?username="+username
    
    
    static let url_searchJSON_countryCode = "https://secure.geonames.org/countryCode?type=JSON&username="+username+"&"
    
    static let url_searchJSON_states = "https://secure.geonames.org/searchJSON?username="+username+"&featureCode=ADM1&adminCode1&style=MEDIUM&country="
    
    
}
