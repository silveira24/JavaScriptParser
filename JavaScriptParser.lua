local m = require 'init'
local coder = require 'coder'
local util = require'util'

local parser = [[
    parser                      <-      statement
    statement                   <-      (block / variableStatement / emptyStatement / expressionStatement / ifStatement)
    block                       <-      '{' statementList? '}'
    statementList               <-      statement+
    variableStatement           <-      varModifier variableDeclarationList eos 
    varModifier                 <-      Var / Let / Const
    Var                         <-      'var'
    Let                         <-      'let' 
    Const                       <-      'const'
    variableDeclarationList     <-      variableDeclaration (',' variableDeclaration)*
    variableDeclaration         <-      (Identifier / arrayLiteral / objectLiteral) ('=' singleExpression)?
    arrayLiteral                <-      ('[' elementList? ']')
    elementList                 <-      (singleExpression (','+ singleExpression)* (','+ lastElement)?) / lastElement
    singleExpression            <-      
    lastElement                 <-      
    objectLiteral               <-      
    eos                         <-      SemiColon / '}' / !EOF
    emptyStatement              <-      SemiColon       
    SemiColon                   <-      ';'
    EOF                         <-      !.
    expressionStatement         <-      !('{' / Function)? expressionSequence eos
    Function                    <-      'function'
    expressionSequence          <-      singleExpression (',' singleExpression)*
    ifStatement                 <-      If '(' expressionSequence ')' statement (Else statement)?
    If                          <-      'if'
    Else                        <-      'else'


]] 

         
g, lab, pos = m.match(s)
print(g, lab, pos)

--gerar o parser
local p = coder.makeg(g)

