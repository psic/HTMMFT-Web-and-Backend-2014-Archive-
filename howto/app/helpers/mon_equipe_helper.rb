module MonEquipeHelper
  # Retourner un titre basé sur la page.
  def titre
    base_titre = "How to manage my football team ?"
    if @titre.nil?
      base_titre
    else
      "#{base_titre} | #{@titre}"
    end
  end
  

end
