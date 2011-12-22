{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
module Gazeta.Utils (fixAuthor, getCharMesh8, liftAuthors, addArticles, knownAuthorExceptions) where
import Gazeta.Types
import qualified Data.Text as T
import qualified Data.List as L
import qualified Data.Text.Encoding as TE
import qualified Data.ByteString.Lazy.Char8 as C
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString as B
import qualified Codec.Text.IConv as IConv

commonFixer :: Char -> Char
commonFixer '“' = '\"'
commonFixer c = c

knownFullExceptions :: [T.Text]
knownFullExceptions = map T.pack exceptions
    where exceptions = ["ii съезд нпср", "студент", "профессор", "журналист", "д.и.н.", "д.м.н", "д.ф.н.", "д.э.н.", "дед из сибири"] ++
		       ["депутат госдумы", "депутат госдумы рф", "депутат госдумы россии", "депутат госдумы от фракции кпрф"] ++
		       ["депутат государственной думы", "депутат государственной думы рф", "профессор мгу", "доктор исторических наук"] ++
		       ["доктор медицинских наук", "доктор права", "доктор технических наук", "доктор философских наук", "доктор экономических наук"] ++
		       ["доцент", "эурналист", "инженер-физик", "кандидит биологических наук", "кандидат наук", "кандидат философских наук"] ++
		       ["капитан 1 ранга", "капитан i ранга", "адвокат", "актер", "юрист", "режиссер", "редакция", "сербский поэт", "старший эксперт"]

knownInitialExceptions :: [T.Text]
knownInitialExceptions = map T.pack exceptions
    where exceptions = ["специальный корреспондент", "сопредседатель координационного совета", "собственный корреспондент", "собственные корреспонденты"] ++
		       ["собкор", "председатель думской", "председатель коми", "председатель партии", "духовник"]

knownAuthorExceptions :: Author -> Bool
knownAuthorExceptions author = (authorName `L.notElem` knownFullExceptions) && (foldl (&&) True (map (\s -> not (s `T.isPrefixOf` authorName)) knownInitialExceptions))
    where authorName = T.toLower $ firstname author

fixAuthor :: Author -> Author
fixAuthor a = Author{firstname=firstname', lastname=lastname', username=username'}
    where fixName s  = T.map commonFixer s
	  firstname' = fixName (firstname a)
	  lastname'  = fixName (lastname a)
	  username'  = fixName (username a)

getCharMesh8 :: C.ByteString -> T.Text
getCharMesh8 charmesh = TE.decodeUtf8 $ B.concat $ BL.toChunks $ IConv.convert "CP1251" "UTF-8" charmesh

liftAuthors :: Maybe [Author] -> [Author]
liftAuthors a = case a of
    Just s  -> s
    Nothing -> []

addArticles :: Issue -> [Article] -> Issue
addArticles issue newarticles = Issue{pub_date = (pub_date issue), articles = newarticles, rubrics=(rubrics issue)}