echo Deploy iniciado 
  
pushd "%DEPLOYMENT_SOURCE%"

::echo Limpando npm cache
::call npm cache clean --force
::rm -rf node_modules

::echo Instalando as dependências
::call npm install

echo Build
call npm run build
IF %ERRORLEVEL% NEQ 0 (
    goto error
)

popd

echo Sincronizando os arquivos
call "%KUDU_SYNC_CMD%" -v 50 -f "%DEPLOYMENT_SOURCE%\build" -t "%DEPLOYMENT_TARGET%" -n "%NEXT_MANIFEST_PATH%" -p "%PREVIOUS_MANIFEST_PATH%" -i ".git;.hg;.deployment;deploy.cmd"
IF %ERRORLEVEL% NEQ 0 (
    goto error
)
:::: DEPLOYMENT_SOURCE: repository
:::: DEPLOYMENT_TARGET: wwwroot

goto end

:error
echo Erro no deploy
exit

:end
echo Deploy finalizado
exit