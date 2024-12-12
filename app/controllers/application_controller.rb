class ApplicationController < ActionController::API
  rescue_from Exception, with: :show_error
  around_action :logging_everything, except: %i[authorized_user? authorization_required show_error logging_everything]

  def authorized_user?
    auth_header = request.headers['Authorization']
    return false unless auth_header

    token = auth_header.split(' ').last
    payload = Tokenization.decode(token)
    return false if payload[:error]

    true
  end

  def authorization_required
    return if authorized_user?

    render json: {
             method: 'api#authorization_required',
             message: {
               'pt-BR': 'É necessária nova conexão',
               'en-US': 'Login needed'
             },
             error: 'authentication not found'
           },
           status: :unauthorized
  end

  def show_error(err)
    error = if Rails.env.production?
              {}
            else
              {
                error: err,
                backtrace: err.backtrace
              }
            end
    render json: error.merge({
                               method: 'api#internal_error',
                               message: {
                                 'pt-BR': 'Erro interno no Servidor',
                                 'en-US': 'Internal Server Error'
                               }
                             }),
           status: :internal_server_error
  end

  def logging_everything
    # logger.info request.inspect
    # puts '============'
    # puts request.fullpath
    # puts '============'

    yield

    # puts response.inspect
  end

  def render_json_missing_params(method)
    render json: {
      method:,
      message: {
        'pt-BR': 'Dados insuficientes',
        'en-US': 'Insufficient data'
      },
      error: 'missing_data'
    }, status: :bad_request
  end
end
