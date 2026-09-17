using System;
using System.Collections.Generic;
using System.Text;

namespace TesteDotNet.Helpers
{
    public class StringHelper
    {
        public string InverterPalavras(string texto)
        {
            ArgumentNullException.ThrowIfNull(texto);

            char[] resultado = texto.ToCharArray();
            int inicioPalavra = 0;

            for (int i = 0; i <= resultado.Length; i++)
            {
                bool fimDoTexto = i == resultado.Length;
                bool encontrouEspaco = !fimDoTexto && char.IsWhiteSpace(resultado[i]);

                if (!fimDoTexto && !encontrouEspaco)
                    continue;

                if(i > inicioPalavra)
                    Array.Reverse(resultado, inicioPalavra, i - inicioPalavra);

                inicioPalavra = i + 1;

            }

            return new string(resultado);
        }
    }
}
