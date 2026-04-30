% This document class provides a simple and beautiful memo for LaTeX users.
% It is based on scrartcl and inherits most of the functionality
% that class.
%
% Author: Rob Oakes, Copyright 2010.  Released under the LGPL, version 3.
%         Updated by Charles A Taylor
% A copy of the LGPL can be found at http://www.gnu.org/licenses/lgpl.html

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{texMemo}[2019/07/25 - Simple Memo Class, Including Logo]

% Load the Base Class
\LoadClassWithOptions{scrartcl}

% Begin Requirements
\RequirePackage{ifthen}

% Set the Paper Size and margins
% TODO: should be aware of A4 vs letter
\RequirePackage{geometry}
\geometry{margin=1.0in}

% Specialized memo Commands (To, From, Subject, Logo)

\def\@memoto{\relax}
\newcommand{\memoto}[1]{\gdef\@memoto{#1}}

\def\@memofrom{\relax}
\newcommand{\memofrom}[1]{\gdef\@memofrom{#1}}

\def\@memosubject{\relax}
\newcommand{\memosubject}[1]{\gdef\@memosubject{#1}}

\def\@memodate{\relax}
\newcommand{\memodate}[1]{\gdef\@memodate{#1}}

\def\@memologo{\relax}
\newcommand{\memologo}[1]{\gdef\@memologo{\protect #1}}

\def\@memoheader{\relax}
\newcommand{\memoheader}[1]{\gdef\@memoheader{#1}}

\def\@memofooter{\relax}
\newcommand{\memofooter}[1]{\gdef\@memofooter{#1}}

\def\@memodraft{\relax}
\newcommand{\memodraft}[1]{\gdef\@memodraft{#1}}

% Custom Document Formatting
\newcommand\decorativeline[1][1pt]{
	\par\noindent%
	\rule[0.5ex]{\linewidth}{#1}\par
}

% Create the Letterhead and To/From Block
\renewcommand{\maketitle}{\makememotitle}
\newcommand\makememotitle{
	{\begin{center}
		\Large\bfseries
		M\textsc{emorandum}
	\end{center}}
	% To, From, Subject Block
    \begin{minipage}[b][][b]{0.7\textwidth}
    	\begin{description}
    	    \itemsep=0pt
    		\ifthenelse{\equal{\@memoto}{\relax}}{}{\item [{To:}] \@memoto}
    		\ifthenelse{\equal{\@memofrom}{\relax}}{}{\item [{From:}] \@memofrom}
    		\ifthenelse{\equal{\@memosubject}{\relax}}{}{\item [{Subject:}] \@memosubject}
    		\ifthenelse{\equal{\@memodate}{\relax}}{}{\item [{Date:}] \@memodate}
    	\end{description}
	\end{minipage}% Letterhead Logo
	\begin{minipage}[b][][b]{0.3\textwidth}
		{
    		\begin{flushright}
    			\ifthenelse{\equal{\@memologo}{\relax}}{}{%
    			    \@memologo
    			}
    		\end{flushright}
    	}
	\end{minipage}
 	\decorativeline\vspace{2pt}\par
	% Print the memo header text directly under the decorative rule on the title page
	\ifthenelse{\equal{\@memoheader}{\relax}}{}{%
		{\centering\@memoheader\par\vspace{2pt}}%
	}
	% ensure the title page doesn't show the top-of-page header (we print it manually)
	\thispagestyle{plain}
}

% don't use indented paragraphs, instead use slight breaks
\KOMAoptions{parskip=half}

\usepackage[T1]{fontenc}

% use all computer roman fonts for consistency and nice looks
\addtokomafont{disposition}{\rmfamily}
\addtokomafont{descriptionlabel}{\rmfamily}

% default LaTeX second-level list is ugly
\renewcommand\labelitemii{$\circ$}

% required if you're using LaTeX created by PanDoc
\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
% Load fancy header/footer and include git version if available
\RequirePackage{fancyhdr}
\IfFileExists{gitversion.tex}{\input{gitversion.tex}}{\providecommand{\gitversion}{}}
% Defer setting the page style until after \begin{document} to avoid KOMA
% resetting it. Apply the fancyhdr configuration at begin document.
\AtBeginDocument{%
	\pagestyle{fancy}%
	\fancyhf{}% clear header/footer
	\renewcommand{\headrulewidth}{0pt}%
	\renewcommand{\footrulewidth}{0pt}%
	% header: use memoheader if provided
	\ifthenelse{\equal{\@memoheader}{\relax}}{}{\fancyhead[C]{\@memoheader}}%
	% footer: combine memofooter (if any) with gitversion
	\ifthenelse{\equal{\@memofooter}{\relax}}{\fancyfoot[C]{\gitversion}}{\fancyfoot[C]{\@memofooter \\ \gitversion}}%
	\fancyfoot[R]{\thepage}%
}

% Ensure the `plain` pagestyle (used by title/first page) matches `fancy`
\fancypagestyle{plain}{%
	\fancyhf{}%
	\renewcommand{\headrulewidth}{0pt}%
	\renewcommand{\footrulewidth}{0pt}%
	% plain: no header (we print header manually under the rule on page one), keep footer
	\ifthenelse{\equal{\@memofooter}{\relax}}{\fancyfoot[C]{\gitversion}}{\fancyfoot[C]{\@memofooter \\ \gitversion}}%
	\fancyfoot[R]{\thepage}%
}
