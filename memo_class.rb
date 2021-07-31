# frozen_string_literal: true

class Memo
  def initialize
    @data = PG.connect(dbname: 'memos_db')
  end

  def read_all_memos
    @data.exec('SELECT * FROM memos_t')
  end

  def create(title, content)
    time = Time.now
    @data.exec('INSERT INTO memos_t(title, content, time) VALUES ($1, $2, $3) RETURNING id', [title, content, time])
  end

  def read_memo(id)
    @data.exec('SELECT * FROM memos_t WHERE id = $1', [id])
  end

  def edit(title, content, id)
    time = Time.now
    @data.exec('UPDATE memos_t SET title = $1, content = $2, time = $3 WHERE id= $4', [title, content, time, id])
  end

  def delete(id)
    @data.exec('DELETE FROM memos_t WHERE id = $1', [id])
  end
end
