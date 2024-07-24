import 'package:flutter/material.dart';

class TermsPageWithoutRegister extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Termos de Compromisso"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Política de Privacidade",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Introdução",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "A presente Política de Privacidade contém informações sobre coleta de dados, uso, compartilhamento e segurança dos dados, além do consentimento e direitos dos usuários e visitantes do aplicativo TECER. A mesma possui a finalidade de demonstrar absoluta transparência quanto ao assunto e esclarecer, a todos interessados, sobre os tipos de dados que são coletados, os motivos da coleta e a forma como os usuários podem gerenciar suas informações pessoais.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Esta Política de Privacidade aplica-se a todos os usuários e visitantes do aplicativo TECER e integra os Termos e Condições Gerais de Uso do aplicativo. A ONG GEMDAC - GENERO MULHER DESENVOLVIMENTO E ACAO PARA A CIDADANIA, CNPJ 06.352.423/0001-57, responsável pelo desenvolvimento do Aplicativo TECER, é a controladora de dados pessoais.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "A GEMDAC sendo responsável pelo tratamento dos seus dados pessoais, se compromete com a proteção dos dados pessoais dos seus usuários, em conformidade com a Lei Federal 13.709/2018 (“Lei Geral de Proteção de Dados Pessoais - LGPD”). Ademais, o documento poderá ser atualizado em decorrência de eventual atualização normativa, razão pela qual se convida o usuário a consultar periodicamente esta seção.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "1. Coleta de Dados e Armazenamento",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "O presente aplicativo coleta dados pessoais como nome, idade, e-mail, município de residência, telefone e dados de uso do app. Ficam cientes os usuários e visitantes de que seu perfil na plataforma estará acessível a todos demais usuários e visitantes da plataforma.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Os dados pessoais do usuário e visitante são armazenados pela plataforma durante o período necessário para o cumprimento das finalidades previstas no presente documento, conforme o disposto no inciso I do artigo 15 da Lei 13.709/18.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "2. Uso dos Dados",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Os dados pessoais do usuário e do visitante coletados e armazenados pelo aplicativo tem por finalidade:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• Bem-estar do usuário e visitante: fornecer e melhorar nossos serviços, facilitar, agilizar e cumprir os compromissos estabelecidos entre o usuário e a empresa, melhorar a experiência dos usuários e fornecer funcionalidades específicas a depender das características básicas do usuário.\n• Autenticação e segurança.\n• Enviar notificações e atualizações.\n• Relatórios, estudos e pesquisas científicas.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "A Lei Geral de Proteção de Dados Pessoais (“LGPD”) nos permite realizar atividades de tratamento para as finalidades acima descritas com fundamento em diferentes hipóteses legais. Em alguns casos, o seu consentimento será imprescindível para a nossa atividade. Em outras situações, poderemos utilizar seus dados pessoais para a tutela da sua saúde, para o atendimento dos nossos legítimos interesses ou de terceiros, para o cumprimento de contratos, para o exercício regular dos nossos direitos, para o cumprimento de obrigações legais e regulatórias, ou, ainda, para a prevenção à fraude.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "O tratamento de dados pessoais para finalidades não previstas nesta Política de Privacidade somente ocorrerá mediante comunicação prévia ao usuário, de modo que os direitos e obrigações aqui previstos permanecem aplicáveis.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "3. Compartilhamento de Dados",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "O compartilhamento de dados dos usuários pode ocorrer somente nas seguintes situações:",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• Órgãos, autoridades e membros do Poder Público, sempre de acordo com as determinações contidas na legislação vigente ou quando necessário para o cumprimento de ordens judiciais ou administrativas;\n• Para composição de relatórios, estudos e pesquisas científicas, com proteção ética e adequada.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "4. Segurança dos Dados",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Adotamos medidas para proteger os dados contra acessos não autorizados e outras ameaças, com atualizações periódicas dos nossos sistemas de segurança. Para isso, adotamos rigorosas medidas de segurança capazes de garantir que suas informações estejam protegidas de acordo com elevados padrões de segurança e proteção, respeitando a legislação vigente.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "5. Consentimento e Direitos dos Usuários",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Ao utilizar os serviços e fornecer as informações pessoais na plataforma, o usuário está consentindo com a presente Política de Privacidade.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "O usuário, ao cadastrar-se, manifesta conhecer e pode exercitar seus direitos de cancelar seu cadastro, acessar e atualizar seus dados pessoais e garante a veracidade das informações por ele disponibilizadas.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "6. Como o usuário pode exercer os seus direitos?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "A Lei Geral de Proteção de Dados Pessoais (“LGPD”) garante a você os seguintes direitos: (a) confirmação da existência de tratamento de dados pessoais; (b) acesso aos dados pessoais tratados pelo aplicativo; (c) correção de dados incompletos, inexatos ou desatualizados; (d) anonimização, bloqueio ou eliminação de dados desnecessários, excessivos ou tratados em desconformidade com o disposto na Lei; (e) portabilidade dos dados a outro fornecedor de serviço ou produto, mediante requisição expressa, de acordo com a regulamentação da Autoridade Nacional de Proteção de Dados (“ANPD”), observados os nossos segredos comerciais; (f) eliminação dos dados pessoais tratados com o seu consentimento; (g) informação das entidades públicas e privadas com as quais realizamos uso compartilhado de seus dados pessoais; (h) informação sobre a possibilidade de não fornecer consentimento e sobre as consequências da negativa; (i) revogação de seu consentimento; e (j) revisão de decisões tomadas unicamente com base em tratamento automatizado de dados pessoais que afetem seus interesses.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Sempre que desejar, você poderá exercer tais direitos por meio dos canais de contato abaixo.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "No entanto, informamos que tais direitos não são absolutos. Em determinadas situações, não poderemos atender às suas solicitações em razão da existência de obrigações legais ou regulatórias que nos impeçam de respeitar sua vontade. Em alguns casos, também, é possível que sua solicitação seja recusada para que possamos assegurar o exercício regular de nossos direitos, quer seja em contratos, quer seja em processos judiciais, administrativos ou arbitrais. Caso isso ocorra, você será devidamente comunicado a respeito da impossibilidade de atendimento, de maneira fundamentada.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "O usuário tem direito de retirar o seu consentimento a qualquer tempo, para tanto deve entrar em contato abaixo. Como também pode corrigir dados pessoais incompletos, inexatos ou desatualizados através do e-mail disponibilizado.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "7. Coleta de dados de pessoas menores de 18 (dezoito) anos",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Se ocorrer a coleta de dados de pessoas menores de dezoito anos, as informações coletadas não serão utilizadas no projeto.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Em cumprimento à legislação vigente, adotamos medidas técnicas, administrativas e organizacionais adicionais quando tratamos dados pessoais de crianças e adolescentes, a fim de garantir a proteção integral e o melhor interesse desses menores. Caso seja extremamente necessária a utilização dos dados, isso será feito mediante consentimento específico dos pais ou responsáveis.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "8. Contato",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Para exercer seus direitos, entre em contato:\nONG GEMDAC, por meio do e-mail: gemdac.mulher@bol.com.br",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "9. Atualizações",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "A presente Política de Privacidade poderá sofrer alterações a qualquer momento em decorrência de atualização normativa ou pela evolução das nossas atividades e adotamos a revisão regular.",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 80), // Espaço para que o botão não fique sobre o texto
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                  );
                },
                child: Icon(Icons.arrow_downward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
