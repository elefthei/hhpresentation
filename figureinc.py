for i in range(0,85,5):
    print r'''% slide $i
\begin{frame}
  \begin{figure}
    \centering
    \includegraphics[width = 0.8\textwidth]{./images/current$i.jpg}
    \caption{HH Models step current response starting at $i $\mu A/cm^2$}
  \end{figure}
\end{frame}

'''.replace('$i',str(i))
